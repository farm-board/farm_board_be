class ApplicantSerializer
  include JSONAPI::Serializer
  attributes :posting_id, :employee_id, :notification
end
