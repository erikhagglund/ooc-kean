/* This file is part of magic-sdk, an sdk for the open source programming language magic.
 *
 * Copyright (C) 2016 magic-lang
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 */

use geometry
use base
import RasterPacked
import RasterImage
import RasterYuvPlanar
import RasterMonochrome
import Image
import Color
import Pen
import Canvas, RasterCanvas

RasterYuv420PlanarCanvas: class extends RasterCanvas {
	target ::= this _target as RasterYuv420Planar
	init: func (image: RasterYuv420Planar) { super(image) }
	_drawPoint: override func (x, y: Int, pen: Pen) {
		position := this _map(IntPoint2D new(x, y))
		if (this target isValidIn(position x, position y))
			this target[position x, position y] = this target[position x, position y] blend(pen alphaAsFloat, pen color toYuv())
	}
}

RasterYuv420Planar: class extends RasterYuvPlanar {
	stride ::= this _y stride
	init: func ~fromRasterImages (y, u, v: RasterMonochrome) { super(y, u, v) }
	init: func ~allocateOffset (size: IntVector2D, stride: UInt, uOffset: UInt, vOffset: UInt) {
		(yImage, uImage, vImage) := This _allocate(size, stride, uOffset, vOffset)
		this init(yImage, uImage, vImage)
	}
	init: func ~allocateStride (size: IntVector2D, stride: UInt) {
		yLength := stride * size y
		uLength := stride * size y / 4
		this init(size, stride, yLength, yLength + uLength)
	}
	init: func ~allocate (size: IntVector2D) { this init(size, size x) }
	init: func ~fromThis (original: This) {
		uOffset := original stride * original size y
		vOffset := uOffset + original stride * original size y / 4
		(yImage, uImage, vImage) := This _allocate(original size, original stride, uOffset, vOffset)
		super(original, yImage, uImage, vImage)
	}
	create: override func (size: IntVector2D) -> Image { This new(size) }
	copy: override func -> This {
		result := This new(this)
		this y buffer copyTo(result y buffer)
		this u buffer copyTo(result u buffer)
		this v buffer copyTo(result v buffer)
		result
	}
	apply: override func ~rgb (action: Func(ColorRgb)) { this apply(ColorConvert fromYuv(action)) }
	apply: override func ~yuv (action: Func (ColorYuv)) {
		yRow := this y buffer pointer
		ySource := yRow
		uRow := this u buffer pointer
		uSource := uRow
		vRow := this v buffer pointer
		vSource := vRow
		width := this size x
		height := this size y

		for (y in 0 .. height) {
			for (x in 0 .. width) {
				action(ColorYuv new(ySource@, uSource@, vSource@))
				ySource += 1
				if (x % 2 == 1) {
					uSource += 1
					vSource += 1
				}
			}
			yRow += this y stride
			if (y % 2 == 1) {
				uRow += this u stride
				vRow += this v stride
			}
			ySource = yRow
			uSource = uRow
			vSource = vRow
		}
		(action as Closure) free()
	}
	apply: override func ~monochrome (action: Func(ColorMonochrome)) { this apply(ColorConvert fromYuv(action)) }
	_createCanvas: override func -> Canvas { RasterYuv420PlanarCanvas new(this) }

	operator [] (x, y: Int) -> ColorYuv {
		ColorYuv new(this y[x, y] y, this u [x / 2, y / 2] y, this v [x / 2, y / 2] y)
	}
	operator []= (x, y: Int, value: ColorYuv) {
		this y[x, y] = ColorMonochrome new(value y)
		this u[x / 2, y / 2] = ColorMonochrome new(value u)
		this v[x / 2, y / 2] = ColorMonochrome new(value v)
	}

	_allocate: static func (size: IntVector2D, stride: UInt, uOffset: UInt, vOffset: UInt) -> (RasterMonochrome, RasterMonochrome, RasterMonochrome) {
		yLength := stride * size y
		uLength := stride * size y / 4
		vLength := uLength
		length := vOffset + vLength
		buffer := ByteBuffer new(length)
		(
			RasterMonochrome new(buffer slice(0, yLength), size, stride),
			RasterMonochrome new(buffer slice(uOffset, uLength), IntVector2D new(size x / 2, size y / 4), stride / 2),
			RasterMonochrome new(buffer slice(vOffset, vLength), IntVector2D new(size x / 2, size y / 4), stride / 2)
		)
	}
	convertFrom: static func (original: RasterImage) -> This {
		result: This
		if (original instanceOf(This))
			result = (original as This) copy()
		else {
			result = This new(original size)
			y := 0
			x := 0
			width := result size x
			yRow := result y buffer pointer
			yDestination := yRow
			uRow := result u buffer pointer
			uDestination := uRow
			vRow := result v buffer pointer
			vDestination := vRow
			f := func (color: ColorYuv) {
				(yDestination)@ = color y
				yDestination += 1
				if (x % 2 == 0 && y % 2 == 0) {
					uDestination@ = color u
					uDestination += 1
					vDestination@ = color v
					vDestination += 1
				}
				x += 1
				if (x >= width) {
					x = 0
					y += 1

					yRow += result y stride
					yDestination = yRow
					if (y % 2 == 0) {
						uRow += result u stride
						uDestination = uRow
						vRow += result v stride
						vDestination = vRow
					}
				}
			}
			original apply(f)
			(f as Closure) free()
		}
		result
	}
}
