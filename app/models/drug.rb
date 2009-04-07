class Drug < OpenMRS
  set_table_name "drug"
  set_primary_key "drug_id"

  has_many :barcodes, :class_name => "DrugBarcode",  :foreign_key => :drug_id
  has_many :drug_orders, :foreign_key => :drug_inventory_id
  has_many :obs, :foreign_key => :value_drug

  belongs_to :concept, :foreign_key => :concept_id
  belongs_to :user, :foreign_key => :user_id

  @@drug_hash_by_name = Hash.new
  @@drug_hash_by_id = Hash.new

  Drug.all.each do |concept|
    @@drug_hash_by_name[concept.name.downcase] = concept
    @@drug_hash_by_id[concept.id] = concept
  end

  # Use the cache hash to get these fast
  def self.find_from_ids(args, options)
    super if args.length > 1 and return
    return @@drug_hash_by_id[args.first] || super
  end

  def self.find_by_name(drug_name)
    return @@drug_hash_by_name[drug_name.downcase] || super
  end

  def type
    self.concept.concept_sets.collect{|concept_set|
      concept_set.name
    }.flatten.join(", ")
  end

  def arv?
    arvs = Concept.find_by_name('ARV Drug').concepts.find_all_by_retired(0).map(&:id)
    arvs.include?(self.concept.id)
  end

  def to_abbreviation
    case self.name
      when "Stavudine 30 Lamivudine 150"
        return "SL: "
      when "Stavudine 40 Lamivudine 150"
        return "SL: "
      when "Stavudine 30 Lamivudine 150 Nevirapine 200"
        return "SLN: "
      when "Stavudine 40 Lamivudine 150 Nevirapine 200"
        return "SLN: "
      when "Efavirenz 600"
        return "E: "
      when "Zidovudine 300 Lamivudine 150"
        return "ZL: "
      when "Nevirapine 200"
        return "N: "
      when "Abacavir 300"
        return "A: "
      when "Didanosine 125"
        return "D: "
      when "Lopinavir 133 Ritonavir 33"
        return "LR: "
      when "Didanosine 200"
        return "D: "
      when "Tenofovir 300"
        return "T: "
      else
        return "Oth: "
    end
  end

  # This method sets up all of the drugs and concepts according to the spreadsheet loaded in the the Regimen class
  def self.update_drugs_and_drug_concepts_from_spreadsheet
    all_combinations = Regimen.all_combinations
    # loop thru all drugs on the spreadsheet - and also add Cotrimoxazole
    all_combinations.collect do |reg|
      reg.drug
    end.uniq.push("Insecticide Treated Net","Cotrimoxazole 480").each do |drug_name|
      if Drug.find_by_name(drug_name).nil?
        drug = Drug.new(:name => drug_name)
        drug_concept_name = drug_name.gsub(/ \d+/,"")
        drug.concept = Concept.find_by_name(drug_concept_name) || Concept.create(:name => drug_concept_name,
          :concept_class => ConceptClass.find_by_name("Drug"), :concept_datatype => ConceptDatatype.find_by_name("Text"))
        drug.combination = !drug.name.match(/ /).nil?
        drug.save
      end
    end
  end

  def month_quantity(year=Date.today.year, month=Date.today.month)
    qty = 0
    drug_orders.each do |drug_order|
      order_date = drug_order.order.encounter.encounter_datetime.to_date
      next unless order_date.year == year and order_date.month == month
      next if drug_order.encounter.voided?
      qty += drug_order.quantity
    end
    return qty
  end

  # Assign this drug to a regimen type e.g. ARV first line regimen
  # e.g.: self.add_to_regimen_type(Concept.find_by_name('ARV first line regimen')) will
  # add this drug an ARV first line regimen drug
  def add_to_regimen_type(regimen_concept)
    return nil if regimen_concept.blank?
    drug_concept = self.concept
    return nil if drug_concept.blank? or User.current_user.nil?
    concept_set = ConceptSet.new(:concept_id => drug_concept.id, :concept_set => regimen_concept.id,
                   :creator => User.current_user.id, :date_created => Time.now)
    concept_set.save
  end

  def short_name
    Concept.find(self.concept_id).short_name rescue nil
  end

end

