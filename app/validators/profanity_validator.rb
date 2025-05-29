class ProfanityValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, 'contains a prohibited word or phrase') \
      if value.present? && PF.profane?(value)
  end
end