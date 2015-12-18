//
// Copyright (c) 2011-2015 Simon Mika <simon@mika.se>
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

use ooc-unit
use ooc-math
use ooc-collections
import lang/IO

FloatVectorListTest: class extends Fixture {
	tolerance := 1.0e-5f

	init: func {
		super("FloatVectorList")
		this add("sum", func {
			list := FloatVectorList new()
			expect(list sum, is equal to(0.0f) within(tolerance))
			list add(-1.0f)
			list add(2.0f)
			list add(-3.0f)
			list add(4.0f)
			expect(list sum, is equal to(2.0f) within(tolerance))
			list free()
		})
		this add("maxValue", func {
			list := FloatVectorList new()
			list add(1.0f)
			expect(list maxValue, is equal to(1.0f) within(tolerance))
			list add(2.0f)
			expect(list maxValue, is equal to(2.0f) within(tolerance))
			list add(3.0f)
			expect(list maxValue, is equal to(3.0f) within(tolerance))
			list add(-3.0f)
			expect(list maxValue, is equal to(3.0f) within(tolerance))
			list add(4.0f)
			expect(list maxValue, is equal to(4.0f) within(tolerance))
			list free()
		})
		this add("mean", func {
			list := FloatVectorList new()
			list add(10.0f)
			list add(20.0f)
			list add(30.0f)
			list add(40.0f)
			expect(list mean, is equal to(25.0f) within(tolerance))
			list free()
		})
		this add("variance", func {
			list := FloatVectorList new()
			list add(10.0f)
			list add(20.0f)
			list add(30.0f)
			list add(40.0f)
			expect(list variance, is equal to(125.0f) within(tolerance))
			list free()
		})
		this add("standard deviation", func {
			list := FloatVectorList new()
			list add(10.0f)
			list add(20.0f)
			list add(30.0f)
			list add(40.0f)
			expect(list standardDeviation, is equal to(125.0f sqrt()) within(tolerance))
			list free()
		})
		this add("sort", func {
			list := FloatVectorList new()
			list add(-1.0f)
			list add(2.0f)
			list add(-3.0f)
			list add(4.0f)
			list sort()
			expect(list[0], is equal to(-3.0f) within(tolerance))
			expect(list[1], is equal to(-1.0f) within(tolerance))
			expect(list[2], is equal to(2.0f) within(tolerance))
			expect(list[3], is equal to(4.0f) within(tolerance))
			list free()
		})
		this add("accumulate", func {
			list := FloatVectorList new()
			list add(-1.0f)
			list add(2.0f)
			list add(-3.0f)
			list add(4.0f)
			result := list accumulate()
			expect(result[0], is equal to(-1.0f) within(tolerance))
			expect(result[1], is equal to(1.0f) within(tolerance))
			expect(result[2], is equal to(-2.0f) within(tolerance))
			expect(result[3], is equal to(2.0f) within(tolerance))
			result free()
			list free()
		})
		this add("copy", func {
			list := FloatVectorList new()
			list add(-1.0f)
			list add(2.0f)
			list add(-3.0f)
			list add(4.0f)
			copy := list copy()
			expect(list count, is equal to(copy count))
			for (i in 0 .. list count)
				expect(copy[i], is equal to(list[i]) within(tolerance))
			list free()
			copy free()
		})
		this add("operator + (This)", func {
			list1 := FloatVectorList new()
			list2 := FloatVectorList new()
			list1 add(9.0f)
			list1 add(8.0f)
			list1 add(7.0f)
			list2 add(2.0f)
			list2 add(1.0f)
			result := list1 + list2
			expect(result count == list2 count)
			expect(result[0], is equal to(11.0f) within(tolerance))
			expect(result[1], is equal to(9.0f) within(tolerance))
			list1 free()
			list2 free()
			result free()
		})
		this add("add into", func {
			list1 := FloatVectorList new()
			list2 := FloatVectorList new()
			list1 add(9.0f)
			list1 add(8.0f)
			list1 add(7.0f)
			list2 add(2.0f)
			list2 add(1.0f)
			list1 addInto(list2)
			expect(list1[0], is equal to(11.0f) within(tolerance))
			expect(list1[1], is equal to(9.0f) within(tolerance))
			expect(list1[2], is equal to(7.0f) within(tolerance))
			list1 free()
			list2 free()
		})
		this add("operator - (This)", func {
			list1 := FloatVectorList new()
			list2 := FloatVectorList new()
			list1 add(9.0f)
			list1 add(8.0f)
			list1 add(7.0f)
			list2 add(2.0f)
			list2 add(1.0f)
			result := list1 - list2
			expect(result count, is equal to(list2 count))
			expect(result[0], is equal to(7.0f) within(tolerance))
			expect(result[1], is equal to(7.0f) within(tolerance))
			list1 free()
			list2 free()
			result free()
		})
		this add("operator * (Float)", func {
			list := FloatVectorList new()
			list add(2.0f)
			list add(1.0f)
			list add(6.0f)
			list add(4.0f)
			list add(7.0f)
			result := list * 5.0f
			expect(result count, is equal to(list count))
			expect(result[0], is equal to(10.0f) within(tolerance))
			expect(result[1], is equal to(5.0f) within(tolerance))
			expect(result[2], is equal to(30.0f) within(tolerance))
			expect(result[3], is equal to(20.0f) within(tolerance))
			expect(result[4], is equal to(35.0f) within(tolerance))
			list free()
			result free()
		})
		this add("operator / (Float)", func {
			list := FloatVectorList new()
			list add(20.0f)
			list add(10.0f)
			list add(60.0f)
			list add(40.0f)
			list add(70.0f)
			result := list / 10.0f
			expect(result count, is equal to(list count))
			expect(result[0], is equal to(2.0f) within (tolerance))
			expect(result[1], is equal to(1.0f) within (tolerance))
			expect(result[2], is equal to(6.0f) within (tolerance))
			expect(result[3], is equal to(4.0f) within (tolerance))
			expect(result[4], is equal to(7.0f) within (tolerance))
			list free()
			result free()
		})
		this add("operator + (Float)", func {
			list := FloatVectorList new()
			list add(2.0f)
			list add(1.0f)
			list add(6.0f)
			list add(4.0f)
			list add(7.0f)
			result := list + 5.0f
			expect(result count, is equal to(list count))
			expect(result[0], is equal to(7.0f) within (tolerance))
			expect(result[1], is equal to(6.0f) within (tolerance))
			expect(result[2], is equal to(11.0f) within (tolerance))
			expect(result[3], is equal to(9.0f) within (tolerance))
			expect(result[4], is equal to(12.0f) within (tolerance))
			list free()
			result free()
		})
		this add("operator - (Float)", func {
			list := FloatVectorList new()
			list add(2.0f)
			list add(1.0f)
			list add(6.0f)
			list add(4.0f)
			list add(7.0f)
			result := list - 5.0f
			expect(result count, is equal to(list count))
			expect(result[0], is equal to(-3.0f) within(tolerance))
			expect(result[1], is equal to(-4.0f) within(tolerance))
			expect(result[2], is equal to(1.0f) within(tolerance))
			expect(result[3], is equal to(-1.0f) within(tolerance))
			expect(result[4], is equal to(2.0f) within(tolerance))
			list free()
			result free()
		})
		this add("array index", func {
			list := FloatVectorList new()
			list add(0.0f)
			list add(-6.0f)
			expect(list[1], is equal to(-6.0f) within(tolerance))
			list[0] = 7.0f
			list[1] = -7.0f
			expect(list[0], is equal to(7.0f) within(tolerance))
			expect(list[1], is equal to(-7.0f) within(tolerance))
			list free()
		})
		this add("to string", func {
			list := FloatVectorList new()
			list add(1.0f)
			list add(2.0f)
			s := list toString()
			expect(s length() > 0)
			expect(s indexOf(1.0f toString()) >= 0)
			expect(s indexOf(2.0f toString()) >= 0)
			list free()
			s free()
		})
		this add("median", func {
			list := FloatVectorList new()
			list add(2.0f)
			expect(list median(), is equal to(2.0f) within(tolerance))
			expect(list median(), is equal to(list fastMedian()) within(tolerance))
			list add(1.0f)
			expect(list median(), is equal to(1.5f) within(tolerance))
			expect(list median(), is equal to(list fastMedian()) within(tolerance))
			list add(6.0f)
			expect(list median(), is equal to(2.0f) within(tolerance))
			expect(list median(), is equal to(list fastMedian()) within(tolerance))
			list add(4.0f)
			expect(list median(), is equal to(3.0f) within(tolerance))
			expect(list median(), is equal to(list fastMedian()) within(tolerance))
			list add(7.0f)
			expect(list median(), is equal to(4.0f) within(tolerance))
			expect(list median(), is equal to(list fastMedian()) within(tolerance))
			list free()
		})
		this add("moving median filter", func {
			list := FloatVectorList new()
			list add(2.0f)
			list add(1.0f)
			list add(6.0f)
			list add(4.0f)
			list add(7.0f)
			filtered := list movingMedianFilter(3)
			expect(filtered count == list count)
			expect(filtered[0], is equal to(1.5f) within(tolerance))
			expect(filtered[1], is equal to(2.0f) within(tolerance))
			expect(filtered[2], is equal to(4.0f) within(tolerance))
			expect(filtered[3], is equal to(6.0f) within(tolerance))
			expect(filtered[4], is equal to(5.5f) within(tolerance))
			list free()
			filtered free()
		})
		this add("absolute", func {
			list := FloatVectorList new()
			list add(2.0f)
			list add(-1.0f)
			list add(-6.0f)
			list add(4.0f)
			list add(-7.0f)
			absolute := list absolute()
			expect(absolute sum, is equal to(20.0f) within(tolerance))
			list free()
		})
		this add("reverse", func {
			list := FloatVectorList new()
			list add(2.0f)
			list add(-1.0f)
			list add(-6.0f)
			list add(4.0f)
			list add(-7.0f)
			reversed := list reverse()
			expect(reversed[0], is equal to(-7.0f) within(tolerance))
			expect(reversed[4], is equal to(2.0f) within(tolerance))
			list free(); reversed free()
		})
		this add("divideByMaxValue", func {
			list := FloatVectorList new()
			list add(2.0f)
			list add(-1.0f)
			list add(4.0f)
			list add(-7.0f)
			divided := list divideByMaxValue()
			expect(divided sum, is equal to(-0.5f) within(tolerance))
			list free(); divided free()
		})
		this add("interpolateLinear", func {
			list := FloatVectorList new()
			list add(2.0f)
			list add(1.0f)
			list add(6.0f)
			list add(4.0f)
			list add(7.0f)
			numberOfPointsBetween := 1
			interpolatedList := list interpolateLinear(numberOfPointsBetween)

			expect(interpolatedList count, is equal to(list count + numberOfPointsBetween * (list count - 1)))
			expect(interpolatedList[0], is equal to(2.0f) within(tolerance))
			expect(interpolatedList[1], is equal to(1.5f) within(tolerance))
			expect(interpolatedList[2], is equal to(1.0f) within(tolerance))
			expect(interpolatedList[3], is equal to(3.5f) within(tolerance))
			list free()
			interpolatedList free()
		})
		this add("interpolateCubicSpline", func {
			list := FloatVectorList new()
			list add(2.0f)
			list add(1.0f)
			list add(6.0f)
			list add(4.0f)
			list add(7.0f)
			numberOfPointsBetween := 1
			interpolatedList := list interpolateCubicSpline(numberOfPointsBetween)

			expect(interpolatedList count, is equal to(list count + numberOfPointsBetween * (list count - 1)))
			expect(interpolatedList[0], is equal to(list[0]) within(tolerance))
			expect(interpolatedList[1], is equal to(0.67634f) within(tolerance))
			expect(interpolatedList[2], is equal to(list[1]) within(tolerance))
			expect(interpolatedList[3], is equal to(3.72098f) within(tolerance))
			expect(interpolatedList[4], is equal to(list[2]) within(tolerance))
			expect(interpolatedList[5], is equal to(5.31473f) within(tolerance))
			expect(interpolatedList[6], is equal to(list[3]) within(tolerance))
			expect(interpolatedList[7], is equal to(4.77009f) within(tolerance))
			expect(interpolatedList[8], is equal to(list[4]) within(tolerance))
			list free()
			interpolatedList free()
		})
		this add("find CrossCorrelation Offset", func {
			list := FloatVectorList new()
			list add(2.0f)
			list add(1.0f)
			list add(6.0f)
			list add(4.0f)
			list add(7.0f)
			list add(6.0f)
			list add(6.0f)
			list add(4.0f)
			list add(7.0f)
			list add(4.0f)
			list add(7.0f)
			shiftedList0 := list shift(2)
			shiftedList1 := list shift(-1)
			shiftedList2 := list shift(0)

			offsetRange := Range new(-3, 3)
			(crossCorrelationList0, offsetValues0) := list calculateCrossCorrelation(shiftedList0, offsetRange)
			(crossCorrelationList1, offsetValues1) := list calculateCrossCorrelation(shiftedList1, offsetRange)
			(crossCorrelationList2, offsetValues2) := list calculateCrossCorrelation(shiftedList2, offsetRange)

			maxIndex0 := crossCorrelationList0 findIndexOfMaximum()
			maxIndex1 := crossCorrelationList1 findIndexOfMaximum()
			maxIndex2 := crossCorrelationList2 findIndexOfMaximum()

			correlationOffset0 := offsetValues0[maxIndex0]
			correlationOffset1 := offsetValues1[maxIndex1]
			correlationOffset2 := offsetValues2[maxIndex2]

			maxValue2 := crossCorrelationList2[maxIndex2]

			expect(correlationOffset0, is equal to(2.0f) within(tolerance))
			expect(correlationOffset1, is equal to(-1.0f) within(tolerance))
			expect(correlationOffset2, is equal to(0.0f) within(tolerance))
			expect(maxValue2, is equal to(1.0f) within(tolerance))
			list free()
			shiftedList0 free()
			shiftedList1 free()
			shiftedList2 free()
			crossCorrelationList0 free()
			crossCorrelationList1 free()
			crossCorrelationList2 free()
			offsetValues0 free()
			offsetValues1 free()
			offsetValues2 free()
		})
	}
}

FloatVectorListTest new() run() . free()
