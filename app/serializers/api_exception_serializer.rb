class ApiExceptionSerializer < ActiveModel::Serializer
  attributes :status, :message
end