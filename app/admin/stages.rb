ActiveAdmin.register Stage do
  permit_params :name, :stage_type

  filter :name
  filter :stage_type

  index do
    id_column
    column :name
    column :stage_type
    actions
  end

end
