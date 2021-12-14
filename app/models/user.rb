#---
# Excerpted from "Agile Web Development with Rails 6",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/rails6 for more book information.
#---
class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  has_secure_password

  after_destroy :ensure_an_admin_remains
  before_destroy :email_verification_check_for_destroy
  before_update :email_verification_check_for_update

  class Error < StandardError
  end

  private
    def ensure_an_admin_remains
      if User.count.zero?
        raise Error.new "Can't delete last user"
      end
    end

    def email_verification_check_for_destroy
      if email == 'admin@depot.com'
        raise Error.new "Can't delete the Admin"
      end
    end

    def email_verification_check_for_update
      if email == 'admin@depot.com'
        raise Error.new "Can't update the details of Admin"
      end
    end
end
