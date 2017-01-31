#coding UTF-8

  US = ("a".."z").to_a
  RU =  File.readlines('alphabet.txt')

  def addError(s,c)
    if c == "en.US" || c == "en.GB"
      return s.insert(rand(s.size),US[rand(US.size)])
    else
      return s.insert(rand(s.size),RU[rand(RU.size)].chomp)
    end
  end

  def addNumError(s)
    return s.insert(rand(s.size),rand(9).to_s)
  end

def removeError(s)
  if s.size<2
    return s+s[0]
  else
  a = rand(s.size)
  return s.slice!(0,a)+s.slice!(1, s.length)
  end
end

def copySymError(s)
  if s.size<1
    return s+s[0]
  else
  a=rand(s.size)
  return s.insert(a,s[a])
    end
end

def changeError(s)
  if s.size<2
    return s+s[0]
  else
  a=rand((s.size)-1)+1
  temp = s[a-1]
  s[a-1]=s[a]
  s[a]=temp
  return s
    end
  end
  
require "docopt"
doc = <<DOCOPT

Usage: 
#{__FILE__} (<region>) (<count_of_lines>) [<count_of_errors>]

<p>Options:
	count_of_errors [default: 0]
DOCOPT
begin
arguments = Docopt::docopt(doc)
region = arguments["<region>"].to_s
count = arguments["<count_of_lines>"].to_i
errors = arguments["<count_of_errors>"].to_f
unless ["en.US","en.GB","ru.RU","by.BY"].include?(region)
  puts "An invalid parameter value <region>  must be language.Region"
  exit(0)
end
if count.to_i<1 || count.to_i>10000001
  puts "An invalid parameter value <count_of_lines>  must be in range [0;10 millions]"
  exit(0)
end
errorForOne = (errors.to_f*count.to_f)/count.to_f

cities = File.readlines(region.downcase+'_cities.txt')
streets= File.readlines(region.downcase+'_streets.txt')
names = File.readlines(region.downcase+'_name_m.txt')
surnames = File.readlines(region.downcase+'_surname_m.txt')
numbers = File.readlines(region.downcase+'_numbers.txt')
i=0
err = 0
loop do
    i+=1
    a=surnames[rand(surnames.size)].chomp
    b=names[rand(names.size)].chomp
    c=streets[rand(streets.size)].chomp
    d=(rand(200)+1).to_s
    e=(rand(500)+1).to_s
    f=cities[rand(cities.size)].chomp
    if region=="en.GB"
      g = numbers[rand(numbers.size)].chomp + (rand(89999)+10000).to_s
    elsif region=="en.US"
      g = numbers[rand(numbers.size)].chomp + (rand(899)+100).to_s+")"+(rand(8999999)+1000000).to_s
      else
      g=numbers[rand(numbers.size)].chomp
    end
    array = [a,b,c,d,e,f,g]
    if errorForOne<1
    err+=errorForOne
    else
      err = 1
end
    if errors>0
      if err>=1
    loop do
      numEl = rand(array.size)
      array[numEl] = changeError(array[numEl])
      err+=1
      break if errors<=err
      numEl = rand(array.size)#346
      if [3,4,6].include?(numEl)
        array[numEl] = addNumError(array[numEl])
      else
      array[numEl] = addError(array[numEl],region)
      end
      err+=1
      break if errors<=err
      numEl = rand(array.size)
      array[numEl] = removeError(array[numEl])
      err+=1
      break if errors<=err
      numEl = rand(array.size)
      array[numEl] = copySymError(array[numEl])
      err+=1
      break if errors<=err

      numEl = rand(array.size)
      array[numEl] = removeError(array[numEl])
      err+=1
      break if errors<=err
    end
    if errorForOne<1
        err = errorForOne
    else
      err=0
      end
    end
    end
    puts  (array[0]+' '+array[1]+'; '+array[2]+', '+array[3]+', '+array[4]+'; '+array[5]+'; ' +array[6]).force_encoding("windows-1251").encode("utf-8")
    break if count<=i
  end
  rescue Docopt::Exit => e
	puts "Not a valid parameters ([lang.Region][userCount][errorsCount])"
	exit
    end