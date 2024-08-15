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
    @available_relations = relations&.keys&.map(&:to_s)

    result_with_belongs_relation = get_all_data_and_belongs_to_hash(relations, excepts)

    relation_result = relation_many_results relations

    result_with_belongs_relation.append(relation_result).compact! if relation_result&.any?
    return result_with_belongs_relation.to_h if args.include? 'callback'

    result_with_belongs_relation.to_h.to_json
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

  private_class_method def self.belongs_to(*params)
    params.each do |param|
      define_method param.name.downcase do
        param.find('id': send("#{param.name.downcase}_id"))[0]
      end
    end
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

  private

  def get_all_data_and_belongs_to_hash(relations, excepts)
    self.class::PARAMS.map do |param|
      if param.match?(/^\w*_id$/) && @available_relations&.include?(param.gsub('_id', ''))
        next get_relation_belongs_to_hash param, relations
      end
      next if excepts&.include? param

      [param, send(param)]
    end.compact
  end

  def get_relation_belongs_to_hash(param, relations)
    param_without_id = param.gsub('_id', '')
    @available_relations.delete param_without_id
    relation_excepts = relations[param_without_id.to_sym]&.dig :excepts
    relation_relations = relations[param_without_id.to_sym]&.dig :relations
    [param_without_id,
     get_class_from_name(param_without_id).find(id: send(param))[0]
                                          .to_json('callback', relations: relation_relations,
                                                               excepts: relation_excepts)]
  end

  def relation_many_results(relations)
    @available_relations&.map do |relation|
      next unless get_class_from_name relation

      hash_result = get_all_objects_by_relation_many(relation).map do |relation_object|
        get_relation_many_hash(relation, relations, relation_object)
      end
      [relation, hash_result]
    end&.compact&.flatten(1)
  end

  def get_relation_many_hash(relation, relations, relation_object)
    relation_excepts = ["#{self.class.name.downcase}_id"]
    if relations[relation.to_sym].instance_of? Hash
      relation_excepts.append(relations[relation.to_sym][:excepts]).flatten!
    end
    relation_relations = relations[relation.to_sym]&.dig(:relations)
    relation_object.to_json('callback', relations: relation_relations, excepts: relation_excepts)
  end

  def get_class_from_name(text)
    Object.const_get(text.split('_').map(&:capitalize).join)
  end

  def get_all_objects_by_relation_many(relation)
    get_class_from_name(relation).find("#{self.class.name.downcase}_id": id)
  end
end
