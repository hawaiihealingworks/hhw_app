# == Schema Information
#
# Table name: patients
#
#  id         :integer          not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do

  before do
    @patient = Patient.new(first_name: "First", last_name: "Last" email: "user@example.com", 
                     password: "foobar", password_confirmation: "foobar")
  end

  subject { @patient }

  it { should respond_to(:first_name) }
  it { should respong_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }

    describe "when first name is not present" do
  	before { @patient.first_name= "" }
  	it {should_not be_valid }
  end

  describe "when last name is not present" do
  	before { @patient.last_name= "" }
  	it {should_not be_valid }
  end

  describe "when email is not present" do
    before { @patient.email = " " }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[patient@foo,com patient_at_foo.org example.patient@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @patient.email = invalid_address
        @patient.should_not be_valid
      end      
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[patient@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @patient.email = valid_address
        @patient.should be_valid
      end      
    end
  end
  
  describe "when email address is already taken" do
    before do
      user_with_same_email = @patient.dup
      user_with_same_email.email = @patient.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

	describe "when password is not present" do
    before { @patient.password = @patient.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @patient.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when password confirmation is nil" do
    before { @patient.password_confirmation = nil }
    it { should_not be_valid }
  end  

  describe "with a password that's too short" do
    before { @patient.password = @patient.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
    before { @patient.save }
    let(:found_patient) { Patient.find_by_email(@patient.email) }

    describe "with valid password" do
      it { should == found_patient.authenticate(@patient.password) }
    end

    describe "with invalid password" do
      let(:patient_for_invalid_password) { found_patient.authenticate("invalid") }

      it { should_not == patient_for_invalid_password }
      specify { patient_for_invalid_password.should be_false }
    end
  end

  describe "remember token" do
    before { @patient.save }
    its(:remember_token) { should_not be_blank }
  end
end