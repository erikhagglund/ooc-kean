//
// Copyright (c) 2011-2014 Simon Mika <simon@mika.se>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

use ooc-math
use ooc-draw
use ooc-draw-gpu
use ooc-base
use ooc-opengl
import math, EglRgba, AndroidContext

GpuPacker: class {
	_renderTarget: Fbo
	_targetTexture: EglRgba
	_context: AndroidContext
	_size: IntSize2D
	size: IntSize2D { get { this _size } }
	_internalSize: IntSize2D
	_bytesPerPixel: UInt
	bytesPerPixel: UInt { get { this _bytesPerPixel } }
	init: func (size: IntSize2D, bytesPerPixel: UInt, context: AndroidContext) {
		this _bytesPerPixel = bytesPerPixel
		this _context = context
		this _size = size
		this _internalSize = IntSize2D new(size width * bytesPerPixel / 4, size height)
		this _bytesPerPixel = bytesPerPixel
		this _targetTexture = context createEglRgba(this _internalSize)
		this _renderTarget = Fbo create(this _targetTexture texture, this _internalSize width, this _internalSize height)
	}
	recycle: func { this _context recycle(this) }
	dispose: func {
		this _targetTexture dispose()
		this _renderTarget dispose()
	}
	pack: func (image: GpuImage, map: OpenGLES3MapDefault) {
		image setMagFilter(false)
		this _renderTarget bind()
		this _renderTarget clear()
		surface := this _context createSurface()
		surface draw(image, map, Viewport new(this _internalSize))
		surface recycle()
		this _renderTarget unbind()
		image setMagFilter(true)
	}
	read: func ~ByteBuffer -> ByteBuffer {
		sourcePointer := this _targetTexture read()
		buffer := ByteBuffer new(sourcePointer, this _targetTexture stride * this _targetTexture size height,
			func (buffer: ByteBuffer){
				this _targetTexture unlock()
				this recycle()
			})
		buffer
	}
	finish: static func { Fbo finish() }
	flush: static func { Fbo flush() }
	readRows: func (destination: RasterImage) {
		sourcePointer := this _targetTexture read()
		destinationPointer := destination pointer
		destinationStride := destination stride
		sourceStride := this _targetTexture stride

		sourceRow := sourcePointer
		destinationRow := destinationPointer
		for(row in 0..destination size height) {
			sourceRow = sourcePointer + row * sourceStride
			destinationRow = destinationPointer + row * destinationStride
			memcpy(destinationRow, sourceRow, destinationStride)
		}
		this _targetTexture unlock()
	}
	read: func (destination: RasterImage) {
		sourcePointer := this _targetTexture read()
		destinationPointer := destination pointer
		destinationStride := destination stride
		sourceStride := this _targetTexture stride
		memcpy(destinationPointer, sourcePointer, destinationStride * destination size height)
		this _targetTexture unlock()
	}
}
