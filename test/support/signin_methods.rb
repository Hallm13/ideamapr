def devise_sign_in(u, scope = :user)
  login_as u, scope: scope
end

def devise_sign_out(u)
  logout u
end
