class PrnodeController < ApplicationController
  def new
  end

  def create
  end

  def get_prnode
    node = ""
    @prnodes.each do |prnode|
    	node = node + prnode.pgnodename
    end
    node
  end
end
