require 'google_drive'

session = GoogleDrive::Session.from_config('config.json')

worksheet = session.spreadsheet_by_key('1SnX7XMGDOi-UREHbQQWEGZwgDaeNYjbjgxSZZysq6kc').worksheets[0]

class Column < Array
  include Enumerable

  def initialize(column, worksheet)
    @column = column
    @worksheet = worksheet
    super()
  end

  def []=(index, value)
    @worksheet[index + 2, @column] = value
    @worksheet.save
  end

  # Sesti zadatak
  def avg
    sum(0.0) / size
  end

  def method_missing(method_name)
    text = method_name.to_s
    (2..@worksheet.num_rows).each do |row|
      return @worksheet.rows[row - 1] if text == @worksheet[row, @column]
    end
  end

  def map(&block)
    result = []
    (2..@worksheet.num_rows).each do |row|
      result << block.call(@worksheet[row, @column].to_i)
    end
    result
  end

  def select(&block)
    result = []
    (2..@worksheet.num_rows).each do |row|
      result << @worksheet[row, @column].to_i if block.call(@worksheet[row, @column].to_i) == true
    end
    result
  end

  def reduce(&block)
    result = 0
    (2..@worksheet.num_rows).each do |row|
      result = block.call(result, @worksheet[row, @column].to_i)
    end
    result
  end
end

class Table
  include Enumerable

  def initialize(worksheet)
    @worksheet = worksheet
    @table = worksheet.rows
  end

  # Treci zadatak
  def each
    (1..@worksheet.num_rows).each do |row|
      (1..@worksheet.num_cols).each do |col|
        yield @worksheet[row, col]
      end
    end
  end

  def to_s
    puts @worksheet.rows
  end

  # Drugi zadatak
  def row(row)
    @rows = []
    (1..@worksheet.num_cols).each do |column|
      @rows << @worksheet[row, column]
    end
    @rows
  end

  def column(column)
    @columns = Column.new(column, @worksheet)
    (2..@worksheet.num_rows).each do |row|
      @columns << @worksheet[row, column].to_i
    end
    @columns
  end

  # Prvi zadatak
  def arr
    @table
  end

  # Peti zadatak
  def [](method_name)
    text = method_name.to_s
    i = 0
    row(1).each do |element|
      i += 1
      return column(i) if element == text
    end
  end

  def method_missing(method_name)
    text = method_name.to_s
    i = 0
    row(1).each do |element|
      element[0] = element[0].downcase
      element.gsub!(' ', '')
      i += 1
      return column(i) if element == text
    end
  end
end

table = Table.new(worksheet)

# # Prvi zadatak
# p table.arr
#
# # Drugi zadatak
# p table.row(1)
# p table.row(2)
#
# # Treci zadatak
# table.each { |x| puts x }
#
# # Peti zadatak
# # a
# p table['Prva Kolona']
#
# # b
# p table['Prva Kolona'][1]
#
# # c
# table['Prva Kolona'][5] = 2125
#
# p table['Prva Kolona']
#
# # Sesti zadatak
# #
# p table.prvaKolona
#
# # a
# p table.prvaKolona.avg
# p table.prvaKolona.sum
#
# # b
# p table.indeks.ri15
#
# # c
# p table.trecaKolona.map { |x| x * 2 }
# p table.drugaKolona.reduce { |x, y| x + y }
# p table.prvaKolona.select { |x| x > 10 }
