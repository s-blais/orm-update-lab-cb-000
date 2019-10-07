require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize (name, grade, id = nil)
    # do I need to use self.name etc here?
    # do I need keyword arguments?
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      )
      SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students"
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
        SQL
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create (name, grade)
    new_student = Self.new
    new_student.save
  end

  def self.new_from_db (array)
    new_student = Self.new
    @id = array[0]
    @name = array[1]
    @grade = array[2]
    #new_student.id = array[0]
    #new_student.name = array[1]
    #new_student.grade = array[2]
  end

  # def self.find_by_name (name)
  #   sql = "SELECT * FROM students WHERE name = ? LIMIT 1"
  #   DB[:conn].execute(sql, name).map |row|
  #     new_from_db(row)
  #   end.first
  # end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end


end
