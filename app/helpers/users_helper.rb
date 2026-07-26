module UsersHelper
  def user_display_name(user)
    [user.first_name, user.last_name]
      .compact_blank
      .join(" ")
  end

  def user_initials(user)
    [user.first_name, user.last_name]
      .compact_blank
      .filter_map { |name| name.first }
      .join
      .upcase
  end
end