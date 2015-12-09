use ooc-unit
use ooc-geometry
use ooc-draw
use ooc-draw-gpu
use ooc-opengl

RasterCanvasTest: class extends Fixture {
	init: func {
		super("RasterCanvas")
		this add("rgb", func {
			input := "test/draw/input/Flower.png"
			output := "test/draw/output/RasterCanvas_Bgr.png"
			image := RasterBgr open(input)
			image canvas pen = Pen new(ColorBgr new(0, 255, 0))
			halfWidth := image size x / 2
			halfHeight := image size y / 2
			start := FloatPoint2D new(-halfWidth, -halfHeight)
			end := FloatPoint2D new(halfWidth, halfHeight)
			image canvas drawLine(start, end)
			start = FloatPoint2D new(halfWidth, -halfHeight)
			end = FloatPoint2D new(-halfWidth, halfHeight)
			image canvas drawLine(start, end)
			image save(output)
			original := RasterBgr open(input)
			//FIXME: This doesn't test if correctly drawn, only if the image has been modified
			expect(original distance(image) > 0.0f)
			original referenceCount decrease()
			image referenceCount decrease()
			input free()
			output free()
		})
		this add("rgba", func {
			input := "test/draw/input/Flower.png"
			output := "test/draw/output/RasterCanvas_Bgra.png"
			image := RasterBgra open(input)
			image canvas pen = Pen new(ColorBgr new(128, 0, 128))
			for (row in 0 .. image size y / 3)
				for (column in 0 .. image size x / 3)
					image canvas drawPoint(FloatPoint2D new(column * 3 - image size x / 2, row * 3 - image size y / 2))
			image save(output)
			original := RasterBgra open(input)
			//FIXME: This doesn't test if correctly drawn, only if the image has been modified
			expect(original distance(image) > 0.0f)
			original referenceCount decrease()
			image referenceCount decrease()
			input free()
			output free()
		})
		this add("yuv420", func {
			input := "test/draw/input/Flower.png"
			output := "test/draw/output/RasterCanvas_Yuv420.png"
			image := RasterYuv420Semiplanar open(input)
			for (i in 0 .. 30) {
				image canvas pen = Pen new(ColorBgr new((i % 10) * 25, (i % 5) * 50, (i % 3) * 80))
				box := IntBox2D createAround(IntPoint2D new(0, 0), IntVector2D new(10 * i, 10 * i))
				image canvas drawBox(FloatBox2D new(box))
			}
			image save(output)
			original := RasterYuv420Semiplanar open(input)
			//FIXME: This doesn't test if correctly drawn, only if the image has been modified
			expect(original distance(image) > 0.0f)
			original referenceCount decrease()
			image referenceCount decrease()
			input free()
			output free()
		})
		this add("monochrome", func {
			input := "test/draw/input/Flower.png"
			output := "test/draw/output/RasterCanvas_Monochrome.png"
			image := RasterMonochrome open(input)
			image canvas pen = Pen new(ColorBgr new(255, 255, 255))
			shiftX := image size x / 2
			shiftY := image size y / 2
			for (i in 0 .. image size x / 10)
				image canvas drawLine(FloatPoint2D new(i * 10 - shiftX, -shiftY), FloatPoint2D new(i * 10 - shiftX, shiftY))
			for (i in 0 .. image size y / 10)
				image canvas drawLine(FloatPoint2D new(-shiftX, i * 10 - shiftY), FloatPoint2D new(shiftX, i * 10 - shiftY))
			image save(output)
			original := RasterMonochrome open(input)
			//FIXME: This doesn't test if correctly drawn, only if the image has been modified
			expect(original distance(image) > 0.0f)
			original referenceCount decrease()
			image referenceCount decrease()
			input free()
			output free()
		})
		this add("monochrome with alpha", func {
			input := "test/draw/input/Flower.png"
			output := "test/draw/output/RasterCanvas_MonochromeWithAlpha.png"
			image := RasterMonochrome open(input)
			image canvas pen = Pen new(ColorBgra new(255, 255, 255, 100))
			shiftX := image size x / 2
			shiftY := image size y / 2
			factor := 2
			for (i in 0 .. image size x / factor)
				image canvas drawLine(FloatPoint2D new(i * factor - shiftX, -shiftY), FloatPoint2D new(i * factor - shiftX, shiftY))
			for (i in 0 .. image size y / factor)
				image canvas drawLine(FloatPoint2D new(-shiftX, i * factor - shiftY), FloatPoint2D new(shiftX, i * factor - shiftY))
			image save(output)
			original := RasterMonochrome open(input)
			//FIXME: This doesn't test if correctly drawn, only if the image has been modified
			expect(original distance(image) > 0.0f)
			original referenceCount decrease()
			image referenceCount decrease()
			input free()
			output free()
		})
		this add("draw bgr image", func {
			inputFlower := "test/draw/input/Flower.png"
			inputSpace := "test/draw/input/Space.png"
			output := "test/draw/output/RasterCanvas_drawYUVonBGR.png"
			imageFlower := RasterYuv420Semiplanar open(inputFlower)
			outputImage := RasterBgr open(inputSpace)
			outputImage canvas interpolationMode = InterpolationMode Smooth
			outputImage canvas draw(imageFlower, IntBox2D new(imageFlower size), IntBox2D new(20, 30, 100, 250))
			imageFlower _coordinateSystem = CoordinateSystem YUpward
			outputImage canvas draw(imageFlower, IntBox2D new(imageFlower size), IntBox2D new(130, 30, 100, 250))
			outputImage canvas interpolationMode = InterpolationMode Fast
			imageFlower _coordinateSystem = CoordinateSystem XLeftward
			outputImage canvas draw(imageFlower, IntBox2D new(imageFlower size), IntBox2D new(240, 30, 100, 250))
			imageFlower _coordinateSystem = CoordinateSystem XLeftward | CoordinateSystem YUpward
			outputImage canvas draw(imageFlower, IntBox2D new(imageFlower size), IntBox2D new(350, 30, 100, 250))
			outputImage save(output)
			imageFlower referenceCount decrease()
			outputImage referenceCount decrease()
			inputFlower free()
			inputSpace free()
			output free()
		})
	}
}

test := RasterCanvasTest new()
test run()
test free()
