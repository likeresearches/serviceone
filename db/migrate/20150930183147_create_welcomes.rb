class CreateWelcomes < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
    	t.string :user
    	t.string :status
    	t.string :latitude
    	t.string :longitude
    	t.string :heading
    	t.string :accuracy
      t.string :speed

      t.timestamps null: false
    end
  end
end
