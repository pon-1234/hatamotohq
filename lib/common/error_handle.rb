# frozen_string_literal: true

module Common
  class ErrorHandle < StandardError
    extend ActiveModel::Naming
    include ActiveModel::Serialization

    attr_reader :status, :message, :status_code

    def initialize
      @status = 'error'
      @message = 'メールアドレスまたはパスワードが違います。'
      @status_code = 401
    end
  end

  class EmailNotPresent < ErrorHandle; end

  class PasswordNotPresent < ErrorHandle; end

  class StaffNotFound < ErrorHandle; end

  class PasswordInvalid < ErrorHandle; end

  class AccessTokenNil < ErrorHandle
    def initialize
      super
      @message = 'アクセストークンが違います。'
      @status_code = 403
    end
  end

  class AccessTokenInvalid < ErrorHandle
    def initialize
      super
      @message = 'アクセストークンが違います。'
      @status_code = 403
    end
  end

  class AlreadyLogedOut < ErrorHandle
    def initialize
      super
      @message = 'すでにログアウトしています。'
      @status_code = 422
    end
  end
end
