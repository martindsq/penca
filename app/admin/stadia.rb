ActiveAdmin.register Stadium do
  permit_params :name, :city

  filter :name
  filter :city

  index do
    id_column
    column :name
    column :city
    actions
  end

end
