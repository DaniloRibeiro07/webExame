# frozen_string_literal: true

require './db/db'

class ApplicationModel
  def initialize(*params)
    return if params[0]&.class != Hash

    params[0].each_pair do |key, value|
      send "#{key}=", value
    rescue NoMethodError
      next
    end
  end

  def to_json(*args, relations: {}, excepts: [])
    relations_not_used = relations&.keys&.map(&:to_s)

    result = self.class::PARAMS.map do |param|
      if param.match?(/^\w*_id$/) && relations_not_used&.include?(param.gsub('_id', ''))
        param_without_id = param.gsub('_id', '')
        param_class_name = convert_to_class_name param_without_id
        relations_not_used.delete param_without_id
        relation_excepts = relations[param_without_id.to_sym][:excepts] if relations[param_without_id.to_sym].instance_of? Hash
        relation_relations = relations[param_without_id.to_sym][:relations] if relations[param_without_id.to_sym].instance_of? Hash

        next [param_without_id, Object.const_get(param_class_name).find(id: send(param))[0].to_json("callback", relations: relation_relations, excepts: relation_excepts)]
      end
      next if excepts&.include? param
      [param, send(param)]
    end.compact

    relation_result = relations_not_used&.map do |relation|
      relation_class_name = convert_to_class_name relation
      next unless Object.const_get(relation_class_name)

      relation_result = Object.const_get(relation_class_name).find(:"#{self.class.name.downcase}_id" => id).map do |relation_internal|
        relation_excepts = ["#{self.class.name.downcase}_id"]
        relation_excepts.append(relations[relation.to_sym][:excepts]).flatten! if relations[relation.to_sym].instance_of? Hash
        relation_relations = relations[relation.to_sym][:relations] if relations[relation.to_sym].instance_of? Hash
        relation_internal.to_json("callback", relations: relation_relations, excepts: relation_excepts)
      end
      [relation, relation_result]
    end&.compact&.flatten(1)

    result.append(relation_result).compact! if relation_result&.any?
    return result.to_h if args.include? "callback"
    result.to_h.to_json
  end 
  #select * from exam_results where exam_id='1';

  def convert_to_class_name(text)
    text.split("_").map(&:capitalize).join
  end

  def self.create(*params)
    return false if params[0]&.class != Hash

    params[0].each_value { |param| return false if param.nil? }

    create_query_sql params[0]
  end

  def self.all
    results = query_sql(<<-SQL_CMD.gsub(/\s+/, ' ').strip
      SELECT * FROM #{self::TABLE_NAME};
    SQL_CMD
                       ).to_a
    return results.map { |result| new(result) } if results.any?

    []
  end

  def self.in_bd?
    return true if query_sql("SELECT * FROM #{self::TABLE_NAME}").class != PG::UndefinedTable

    false
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
      pgdb = PG.connect host: 'PGExame', user: 'admin', password: 'admin', dbname: Db.name
      result = pgdb.exec(sql)
    rescue StandardError => e
      result = e
    end
    pgdb.close
    result
  end

  private_class_method def self.create_query_sql(*params)
    params_sql = params[0].values.map { |param| param&.gsub("'", "''") }.join("', '")
    query_sql <<-SQL_CMD.gsub(/\s+/, ' ').strip
    INSERT INTO #{self::TABLE_NAME} (#{params[0].keys.map(&:to_s).join ', '})
    VALUES ('#{params_sql}');
    SQL_CMD
  end
end
