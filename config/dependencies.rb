require_relative "../app/presentation/cli/user_cli"

module Dependencies
  class << self
    # TODO
    # アプリケーションで使用する依存関係をここで組み立てる。
    #
    # 例：
    # - UserRepository
    # - CreateUser
    # - FindUser
    # - UserCLI
    #
    # UserクラスやUse Caseが実装されたら追加すること。
    def build
      UserCLI.new
    end
  end
end
