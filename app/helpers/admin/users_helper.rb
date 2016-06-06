module Admin::UsersHelper
  def get_roles
    Role.where(:id => 1..2)
  end
end
