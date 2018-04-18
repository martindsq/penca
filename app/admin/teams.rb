ActiveAdmin.register Team do
  permit_params :name

  filter :name
  
  index do
    id_column
    column :name
    actions
  end
  
end
