# frozen_string_literal: true

class ApiExceptionSerializer < ActiveModel::Serializer
  attributes :status, :message
end
