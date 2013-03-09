# coding: utf-8
require 'spec_helper'
require 'db_init'

class TestMigration < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.column :code, :integer
    end
  end

  def self.down
    drop_table :users
  end
end

class User < ActiveRecord::Base
  roles_field :code, :roles => [:admin, :manager, :editor, :reader]
end

describe RolesField::Base do
  describe '权限设置方法' do
    before(:all) {TestMigration.up}
    after(:all) {TestMigration.down}
    
    before {
      @user = User.create
    }

    describe '#roles' do
      it '新对象应该没有角色' do
        @user.roles.should == []
      end
    end

    describe '#roles #set_role' do
      it '设置角色后，对象具有相应角色' do
        @user.set_role :admin
        @user.roles.should == [:admin]
        @user.set_role :manager
        @user.roles.should == [:manager]
        @user.roles.should_not == [:admin]
      end
    end

    describe '#role? #set_role' do
      it '设置角色后，对象可以判断是否具有某些角色' do
        @user.set_role :admin
        @user.role?(:admin).should == true
        @user.is_admin?.should == true
        @user.role?(:editor).should == false
        @user.is_editor?.should == false
      end
    end

    describe '#set_role #reload' do
      it '设置角色后，需要save才能持久化' do
        @user.set_role :editor
        @user.save
        @user.reload
        @user.roles.should == [:editor]

        @user.role = :reader
        @user.reload
        @user.roles.should == [:editor]
      end
    end
  end

  describe '查询方法' do
    before(:all) {TestMigration.up}
    after(:all) {TestMigration.down}

    before {
      [
        :admin, 
        :manager, :manager,
        :editor, :editor, :editor,
        :reader, :reader, :reader, :reader
      ].each { |x|
        user = User.create(:role => x)
      }
    }

    describe '.with_role' do
      it '可以根据角色查询对象' do
        User.with_role(:admin).count.should == 1
        User.with_role(:manager).count.should == 2
        User.with_role(:editor).count.should == 3
        User.with_role(:reader).count.should == 4
      end
    end
  end
end