module Dynameister
  class Collection < Array

    attr_reader :pager, :model

    def initialize(pager, model)
      @pager = pager
      @model = model
      replace pager.items.map { |item| model.new(item) }
    end

    def next_page?
      pager ? pager.next_page? : false
    end

    def last_page?
      pager ? pager.last_page? : true
    end

    def next_page
      return self.class.new(pager.next_page, model) if pager.next_page?
      self.class.new
    end

    def each_page(&block)
      pager.each do |page|
        yield self.class.new(page, model)
      end
    end

    def last_evaluated_key
      pager.last_evaluated_key
    end
  end

end
