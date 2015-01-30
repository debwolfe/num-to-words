class TranslateNumber

  def initialize(number)
    @number = number
    # This array is in reverse order, 0 member is rightmost set of 3 numbers
    @number_triples = @number.to_s.reverse.chars.each_slice(3).map(&:join).map(&:reverse).map(&:to_i)
    if !@number.is_a? Integer
     raise ArgumentError.new("{#{@number} must be a whole number")
   end
  end

  def number_modifier(num)
  # num is the number_triples array index * 3
    if num < 3
      return
    end
    #key is x where 10 to the power of x equals numeric equivalent of value
    modifier_lookup = { 63 =>"vigintilliion", 60 =>"novemdecillion", 57 =>"octodecillion", 54 =>"setpendecillion", 51 =>"sexdecillion",
      48 => "quindecillion", 45 =>"quatturodecillion", 42 =>"tredecillion", 39 =>"duodecillion", 36 =>"undecillion", 33 =>"decillion",
      30 =>"nonillion", 27 =>"octillion", 24 =>"septillion", 21 =>"sextillion", 18 =>"quintillion", 15 =>"quadrillion", 12 =>"trillion",
      9 =>"billion", 6 =>"million", 3 =>"thousand"}
      return modifier_lookup[num] << ","
    end

  def translate_digit(digit)
    digit_lookup = {0 => "", 1 =>"one", 2 =>"two", 3 =>"three", 4 =>"four", 5 =>"five", 6 =>"six", 7 =>"seven", 8 =>"eight", 9 =>"nine"}
    digit_lookup[digit]
  end

  def translate_tens(tens)
      teens_lookup = {10 => "ten", 11 =>"eleven", 12 =>"twelve", 13 =>"thirteen", 14 =>"fourteen", 15 =>"fifteen", 16 =>"sixteen",
       17 =>"seventeen", 18 =>"eighteen", 19 =>"nineteen"}

      tens_lookup = {0 => "", 1 => "", 2 =>"twenty", 3 =>"thirty", 4 =>"forty", 5 =>"fifty", 6 =>"sixty", 7 =>"seventy", 8 =>"eighty",
       9 =>"ninety"}

      if tens == "00"
        return ""
      elsif tens.to_i.between?( 1, 9 )
         return translate_digit(tens.to_i)
      elsif tens.to_i.between?( 10, 20 )
          return teens_lookup[tens.to_i]
      else
        tens_place = tens[0].to_i
        digit = tens[1].to_i
         return tens_lookup[tens_place]  << " " <<  translate_digit(digit)
      end
  end

  def translate_hundreds(hundreds)
    if hundreds.to_s.length ==  3
      return translate_digit(hundreds.to_s[0].to_i) << " hundred " <<  translate_tens(hundreds.to_s[1..2])
    elsif hundreds.to_s.length == 2
      return translate_tens(hundreds.to_s[0..1])
    else
      return translate_digit(hundreds.to_s[0].to_i)
    end
  end

  def get_sign
    if @number < 0
      return "negative"
    else
      return ""
    end
  end

  def trim_trailing_comma(words)
    if words.reverse[0] == ","
      return words.chop
    else
      return words
    end
  end

  def translate
    if @number == 0
      return "zero"
    else
      translation = [ ]
      @number_triples.each_with_index { | group_value, group_index |
        if !(group_value == 0)
          number_translation = translate_hundreds(group_value).chomp(" ")
          modifier = number_modifier(group_index * 3)
          translation << [[number_translation, modifier]]
        end
      }
      words = translation.reverse.join(" ").chomp(" ").chomp(" ")
      return get_sign << trim_trailing_comma(words)
    end
  end


end


# DRIVER TESTS
# Add a test here to prove a deficiency
digit_translator = TranslateNumber.new(1)
p digit_translator.translate_digit(1) == "one"

translator1 = TranslateNumber.new(1)
p translator1.translate  == "one"

translator11 = TranslateNumber.new(11)
p translator11.translate  == "eleven"

tens_translator = TranslateNumber.new(10)
p tens_translator.translate  == "ten"

translator10 = TranslateNumber.new(10)
p translator10.translate  == "ten"

translator90 = TranslateNumber.new(90)
p translator90.translate  == "ninety"

translator_power2 = TranslateNumber.new(100)
p translator_power2.translate == "one hundred"

translator101= TranslateNumber.new(101)
p translator101.translate =="one hundred one"

translator110 = TranslateNumber.new(110)
p translator110.translate == "one hundred ten"

translator111 = TranslateNumber.new(111)
p translator111.translate == "one hundred eleven"

small_thousands = 10**3
translator_small_thousands = TranslateNumber.new(small_thousands)
p translator_small_thousands.translate == "one thousand"

middle_thousands = 10**4
translator_middle_thousands = TranslateNumber.new(middle_thousands)
p translator_middle_thousands.translate == "ten thousand"

big_thousands = 10**5
translator_big_thousands = TranslateNumber.new(big_thousands)
p translator_big_thousands.translate =="one hundred thousand"

bigger_thousands = 10**12
translator_bigger_thousands = TranslateNumber.new(bigger_thousands)
p translator_bigger_thousands.translate =="one trillion"

vigintilliion = 10**63
translator_vigintillion = TranslateNumber.new(vigintilliion)
p translator_vigintillion.translate.include? "vigintilliion"

negative_large = - 10**63
translator_negative_large = TranslateNumber.new(negative_large)
p translator_negative_large.translate.include? "negative"

zero = TranslateNumber.new(0)
puts zero.translate == "zero"

one = TranslateNumber.new(1)
puts one.translate == "one"

ten = TranslateNumber.new(10)
puts ten.translate == "ten"

eleven = TranslateNumber.new(11)
puts eleven.translate == "eleven"

twenty_seven = TranslateNumber.new(27)
puts twenty_seven.translate == "twenty seven"

fifty = TranslateNumber.new(50)
puts fifty.translate == "fifty"

one_hundred = TranslateNumber.new(100)
puts one_hundred.translate == "one hundred"

one_hundred_one = TranslateNumber.new(101)
puts one_hundred_one.translate == "one hundred one"

five_hundred = TranslateNumber.new(500)
puts five_hundred.translate == "five hundred"

eight_hundred_twenty_one = TranslateNumber.new(821)
puts eight_hundred_twenty_one.translate == "eight hundred twenty one"

one_hundred_thousand = TranslateNumber.new(100000)
puts one_hundred_thousand.translate == "one hundred thousand"

thousands = TranslateNumber.new(123204)
puts thousands.translate == "one hundred twenty three thousand, two hundred four"

millions = TranslateNumber.new(1432980)
puts millions.translate == "one million, four hundred thirty two thousand, nine hundred eighty"
