class WeightForHeight < ActiveRecord::Base
  set_table_name :weight_for_heights

  def self.patient_weight_for_height_values
    height_for_weight = Hash.new
    find(:all).each{|hwt|
      height_for_weight[hwt.supine_cm] = hwt.median_weight_height
    }
    return height_for_weight
  end

  def self.significant(patient_height)
    decimal_digit       = patient_height % 1
    siginificant_height = patient_height.round
    siginificant_height = patient_height.round - 0.5 if decimal_digit >= 0.5
    return siginificant_height
  end

end
