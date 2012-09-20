class ClubMemberSession < UserSession

  find_by_login_method :find_login

end