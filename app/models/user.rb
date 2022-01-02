#---
# Excerpted from "Agile Web Development with Rails 6",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/rails6 for more book information.
#---
class User < ApplicationRecord

  ADMIN_EMAIL = 'admin@depot.com'
  has_many :orders
  validates :name, presence: true, uniqueness: true
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  has_secure_password

  after_destroy :ensure_an_admin_remains
  before_destroy :cant_delete_admin, if: :admin?
  before_update :cant_update_admin, if: :admin?

  class Error < StandardError
  end

  private
    def admin?
      self.email == ADMIN_EMAIL
    end

    def ensure_an_admin_remains
      if User.count.zero?
        raise Error.new "Can't delete last user"
      end
    end

    def cant_delete_admin
        # raise Error.new "Can't delete the Admin"
        puts "You can't delete admin"
        self.errors.add :base, message: "Can't delete the Admin ;_;"
        throw :abort
    end

    def cant_update_admin
        # raise Error.new "Can't update the details of Admin"
        puts "You can't edit admin"
        self.errors.add :base, "Can't edit the Admin"
        throw :abort
    end
end
