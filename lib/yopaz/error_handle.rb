module Yopaz
  class ErrorHandle < StandardError
    extend ActiveModel::Naming
    include ActiveModel::Serialization

    attr_reader :status, :message

    def initialize
      @status = 'error'
      @message = 'メールアドレスまたはパスワードが違います。'
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
    end
  end

  class AccessTokenInvalid < ErrorHandle
    def initialize
      super
      @message = 'アクセストークンが違います。'
    end
  end

  class AlreadyLogedOut < ErrorHandle
    def initialize
      super
      @message = 'すでにログアウトしています。'  
    end
  end
end

