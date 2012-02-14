module Derpsy
  
  class Pull
    
    def initialize(id, hash, repo)
      @id = id
      @hash = hash
      @repo = repo
    end

    attr_reader  :id,
                 :hash,
                 :repo

  end

end
