class AddRelationsToDatabase < ActiveRecord::Migration
	def change
		create_table :tasks_users, :id => false do |t|
			t.integer :task_id
			t.integer :user_id
		end
		create_table :task_categories_tasks, :id => false do |t|
			t.integer :task_id
			t.integer :task_category_id
		end
		create_table :projects_users, :id => false do |t|
			t.integer :project_id
			t.integer :user_id
		end
		create_table :user_roles_users, :id => false do |t|
			t.integer :user_id
			t.integer :user_role_id
		end
		add_column :tasks, :project_id, :integer
		add_column :user_roles, :project_id, :integer
		add_column :task_categories, :project_id, :integer


	end
	def down
		drop_table :tasks_users
		drop_table :tasks_task_categories
		drop_table :projects_users
		drop_table :users_user_roles
		remove_column :tasks, :project_id
		remove_column :user_roles, :project_id
		remove_column :task_categories, :project_id
	end
end
