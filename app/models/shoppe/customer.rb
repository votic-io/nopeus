module Shoppe
  class Customer < ActiveRecord::Base
    include ApplicationModel
    has_secure_password

    # Customers can have properties
    key_value_store :properties

    EMAIL_REGEX = /\A\b[A-Z0-9\.\_\%\-\+]+@(?:[A-Z0-9\-]+\.)+[A-Z]{2,6}\b\z/i
    PHONE_REGEX = /\A[+?\d\ \-x\(\)]{7,}\z/

    self.table_name = 'shoppe_customers'

    has_many :addresses, dependent: :restrict_with_exception, class_name: 'Shoppe::Address'

    has_many :orders, dependent: :restrict_with_exception, class_name: 'Shoppe::Order'

    # Validations
    validates :email_address, presence: true, uniqueness: {scope: :application_id}, format: { with: EMAIL_REGEX }
    validates :phone_number, presence: true, format: { with: PHONE_REGEX }

    # All customers ordered by their ID desending
    scope :ordered, -> { order(id: :desc) }

    # The name of the customer in the format of "Company (First Last)" or if they don't have
    # company specified, just "First Last".
    #
    # @return [String]
    def name
      company.blank? ? full_name : "#{company} (#{full_name})"
    end

    # The full name of the customer created by concatinting the first & last name
    #
    # @return [String]
    def full_name
      "#{first_name} #{last_name}"
    end

    def self.ransackable_attributes(_auth_object = nil)
      %w(id first_name last_name company email_address phone_number mobile) + _ransackers.keys
    end

    def self.ransackable_associations(_auth_object = nil)
      []
    end

    # Reset the user's password to something random and e-mail it to them
    def reset_password!
      self.password = SecureRandom.hex(8)
      self.password_confirmation = password
      self.save
      #Shoppe::UserMailer.new_password(self).deliver
    end

    # Attempt to authenticate a user based on email_address & password. Returns the
    # user if successful otherwise returns false.
    #
    # @param email_address [String]
    # @param paassword [String]
    # @return [Shoppe::User]
    def self.authenticate(email_address, password)
      user = where(email_address: email_address).first
      return false if user.nil?
      return false unless user.authenticate(password)
      user
    end
  end
end
