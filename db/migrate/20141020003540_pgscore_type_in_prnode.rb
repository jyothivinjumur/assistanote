class PgscoreTypeInPrnode < ActiveRecord::Migration
	def change		
		change_column :prnodes, :pgscore, :decimal, :precision => 10, :scale => 2		
	end	
end
