# frozen_string_literal: true

class ApplicationModel
  def initialize(*params)
    return if params[0]&.class != Hash

    params[0].each_pair do |key, value|
      send "#{key}=", value
    rescue NoMethodError
      next
    end
  end

  def self.create(*params)
    return false if params[0]&.class != Hash

    params_sql = params[0].values.map { |param| param.gsub("'", "''") }.join("', '")
    query_sql <<-SQL_CMD.gsub(/\s+/, ' ').strip
    INSERT INTO #{self::TABLE_NAME} (#{params[0].keys.map(&:to_s).join ', '})
    VALUES ('#{params_sql}');
    SQL_CMD
  end

  def self.all
    query_sql(<<-SQL_CMD.gsub(/\s+/, ' ').strip
      SELECT * FROM #{self::TABLE_NAME};
    SQL_CMD
             ).to_a
  end

  def self.created?
    true if query_sql("SELECT * FROM #{self::TABLE_NAME}").class != PG::UndefinedTable
  end

  def self.find(*params)
    return false if params[0]&.class != Hash

    sql_params = params[0].map { |key, value| "#{key}='#{value}'" }.join ' AND '

    results = query_sql(<<-SQL_CMD.gsub(/\s+/, ' ').strip
      SELECT * FROM #{self::TABLE_NAME}
      WHERE (#{sql_params});
    SQL_CMD
                       ).to_a
    return false if results.empty?

    results.map { |result| new(result) }
  end

  private_class_method def self.query_sql(sql)
    begin
      pgdb = PG.connect host: 'PGExame', user: 'admin', password: 'admin', dbname: 'db'
      result = pgdb.exec(sql)
    rescue StandardError => e
      result = e
    end
    pgdb.close
    result
  end
end
