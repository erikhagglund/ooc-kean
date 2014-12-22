/*
* Copyright (C) 2014 - Simon Mika <simon@mika.se>
*
* This sofware is free software; you can redistribute it and/or
* modify it under the terms of the GNU Lesser General Public
* License as published by the Free Software Foundation; either
* version 2.1 of the License, or (at your option) any later version.
*
* This software is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License
* along with this software. If not, see <http://www.gnu.org/licenses/>.
*/

use ooc-math
import structs/FreeArrayList, GpuImage, GpuMonochrome, GpuBgr, GpuBgra, GpuUv, GpuYuv420Semiplanar, GpuYuv420Planar

GpuImageBin: class {
	_monochrome: FreeArrayList<GpuImage>
	_bgr: FreeArrayList<GpuImage>
	_bgra: FreeArrayList<GpuImage>
	_uv: FreeArrayList<GpuImage>
	_yuvSemiplanar: FreeArrayList<GpuImage>
	_yuvPlanar: FreeArrayList<GpuImage>

	init: func {
		this _monochrome = FreeArrayList<GpuImage> new()
		this _bgr = FreeArrayList<GpuImage> new()
		this _bgra = FreeArrayList<GpuImage> new()
		this _uv = FreeArrayList<GpuImage> new()
		this _yuvSemiplanar = FreeArrayList<GpuImage> new()
		this _yuvPlanar = FreeArrayList<GpuImage> new()
	}
	dispose: func {
		for(i in 0..this _monochrome size)
			this _monochrome[i] dispose()
		for(i in 0..this _bgr size)
			this _bgr[i] dispose()
		for(i in 0..this _bgra size)
			this _bgra[i] dispose()
		for(i in 0..this _uv size)
			this _uv[i] dispose()
		for(i in 0..this _yuvSemiplanar size)
			this _yuvSemiplanar[i] dispose()
		for(i in 0..this _yuvPlanar size)
			this _yuvPlanar[i] dispose()

		this _monochrome clear()
		this _bgr clear()
		this _bgra clear()
		this _uv clear()
		this _yuvSemiplanar clear()
		this _yuvPlanar clear()
	}
	add: func (image: GpuImage) {
		match (image) {
			case (i: GpuMonochrome) =>
				this _monochrome add(image)
			case (i: GpuBgr) =>
				this _bgr add(image)
			case (i: GpuBgra) =>
				this _bgra add(image)
			case (i: GpuUv) =>
				this _uv add(image)
			case (i: GpuYuv420Semiplanar) =>
				this _yuvSemiplanar add(image)
			case (i: GpuYuv420Planar) =>
				this _yuvPlanar add(image)
		}
	}
	_search: func (size: IntSize2D, arrayList: FreeArrayList<GpuImage>) -> GpuImage {
		result := null
		index := 0
		for (i in 0..arrayList size) {
			image := arrayList[i]
			if (image size width == size width && image size height == size height) {
				result = image
				index = i
				break
			}
		}
		if (result != null)
			arrayList removeAt(index, false)
		result
	}
	find: func (type: GpuImageType, size: IntSize2D) -> GpuImage {
		result := null
		result = match (type) {
			case GpuImageType monochrome => this _search(size, this _monochrome)
			case GpuImageType uv => this _search(size, this _uv)
			case GpuImageType bgr => this _search(size, this _bgr)
			case GpuImageType bgra => this _search(size, this _bgra)
			case GpuImageType yuvSemiplanar => this _search(size, this _yuvSemiplanar)
			case GpuImageType yuvPlanar => this _search(size, this _yuvPlanar)
		}
		result
	}
}
