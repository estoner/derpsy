module Derpsy
  
  class Pull
    
    def initialize(id, hash, repo, short_repo, user, title, web_url)
      @id = id
      @hash = hash
      @repo = repo
      @short_repo = short_repo
      @user = user
      @title = title
      @web_url = web_url
    end

    attr_reader  :id,
                 :hash,
                 :repo,
                 :short_repo,
                 :user,
                 :title,
                 :web_url

  end

end
