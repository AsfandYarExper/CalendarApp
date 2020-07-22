class Events
  attr_accessor :name, :date, :status, :size

  def initialize(name, date, status, size)
    @name = name
    @date = date
    @status = status
    @size = size
  end
end