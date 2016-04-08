/* This file is part of magic-sdk, an sdk for the open source programming language magic.
 *
 * Copyright (C) 2016 magic-lang
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 */

use base
use geometry
use collections
use draw
import Image
import Pen
import DrawState

InterpolationMode: enum {
	Fast // nearest neighbour
	Smooth // bilinear
}

Canvas: abstract class {
	_size: IntVector2D
	_transform := FloatTransform3D identity
	size ::= this _size
	viewport: IntBox2D { get set }
	blend: Bool { get set }
	opacity: Float { get set }
	transform: FloatTransform3D { get { this _transform } set(value) { this _transform = value } }
	focalLength: Float { get set }
	interpolationMode: InterpolationMode { get set }
	init: func (=_size) {
		this viewport = IntBox2D new(this size)
		this focalLength = 0.0f
		this blend = false
		this opacity = 1.0f
		this interpolationMode = InterpolationMode Fast
	}
	drawPoint: virtual func ~white (position: FloatPoint2D) { this drawPoint(position, Pen new(ColorRgba white)) }
	drawPoint: virtual func ~explicit (position: FloatPoint2D, pen: Pen) {
		list := VectorList<FloatPoint2D> new()
		list add(position)
		this drawPoints(list, pen)
		list free()
	}
	drawLine: virtual func ~white (start, end: FloatPoint2D) { this drawLine(start, end, Pen new(ColorRgba white)) }
	drawLine: virtual func ~explicit (start, end: FloatPoint2D, pen: Pen) {
		list := VectorList<FloatPoint2D> new()
		list add(start) . add(end)
		this drawLines(list, pen)
		list free()
	}
	drawPoints: func ~white (pointList: VectorList<FloatPoint2D>) { this drawPoints(pointList, Pen new(ColorRgba white)) }
	drawPoints: abstract func ~explicit (pointList: VectorList<FloatPoint2D>, pen: Pen)
	drawLines: func ~white (pointList: VectorList<FloatPoint2D>) { this drawLines(pointList, Pen new(ColorRgba white)) }
	drawLines: abstract func ~explicit (lines: VectorList<FloatPoint2D>, pen: Pen)
	drawBox: virtual func ~white (box: FloatBox2D) { this drawBox(box, Pen new(ColorRgba white)) }
	drawBox: virtual func ~explicit (box: FloatBox2D, pen: Pen) {
		positions := VectorList<FloatPoint2D> new()
		positions add(box leftTop)
		positions add(box rightTop)
		positions add(box rightBottom)
		positions add(box leftBottom)
		positions add(box leftTop)
		this drawLines(positions, pen)
		positions free()
	}
	fill: abstract func (color: ColorRgba)
	draw: virtual func ~DrawState (drawState: DrawState) { Debug error("draw~DrawState unimplemented for class " + this class name + "!") }
	write: virtual func (target, fontAtlas: Image, localOrigin: IntPoint2D, message: Text) {
		// Generic reference implementation with all inputs that are used from DrawState to simplify input space partitioning
		skippedRows := 2
		visibleRows := 6
		columns := 16
		charSize := fontAtlas size / IntVector2D new(columns, visibleRows)
		viewport := IntBox2D new(localOrigin, charSize)
		targetOffset := IntPoint2D new(0, 0)
		characterDrawState := DrawState new(target) setInputImage(fontAtlas) setBlendMode(BlendMode Add)
		for (i in 0 .. message count) {
			charCode := message[i] as Int
			sourceX := charCode % columns
			sourceY := (charCode / columns) - skippedRows
			source := FloatBox2D new((sourceX as Float) / columns, (sourceY as Float) / visibleRows, 1.0f / columns, 1.0f / visibleRows)
			if (charCode > 32 && charCode < 127)
				characterDrawState setViewport(viewport + (targetOffset * charSize)) setSourceNormalized(source) draw()
			targetOffset x += 1
			if (charCode == '\n') {
				targetOffset x = 0 // Carriage return
				targetOffset y += 1 // Line feed
			}
		}
		message free(Owner Receiver)
	}
	draw: abstract func ~ImageSourceDestination (image: Image, source, destination: IntBox2D)
	draw: func ~ImageDestination (image: Image, destination: IntBox2D) { this draw(image, IntBox2D new(image size), destination) }
	draw: func ~Image (image: Image) { this draw(image, IntBox2D new(image size)) }
	draw: func ~ImageTargetSize (image: Image, targetSize: IntVector2D) { this draw(image, IntBox2D new(targetSize)) }
}
