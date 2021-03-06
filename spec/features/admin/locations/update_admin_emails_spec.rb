require 'rails_helper'

feature 'Update admin_emails' do
  background do
    @location = create(:location)
    login_super_admin
    visit '/admin/locations/vrs-services'
  end

  scenario 'when no admin_emails exist' do
    expect(page).to have_no_xpath("//input[@name='location[admin_emails][]']")
    expect(page).to_not have_link I18n.t('admin.buttons.delete_admin')
  end

  scenario 'by adding 2 new admins', :js do
    add_two_admins
    total_admins = page.
                   all(:xpath, "//input[@name='location[admin_emails][]']")
    expect(total_admins.length).to eq 2
    delete_all_admins
    expect(page).to have_no_xpath("//input[@name='location[admin_emails][]']")
  end

  scenario 'with empty admin', :js do
    find_link(I18n.t('admin.buttons.add_admin')).click
    click_button I18n.t('admin.buttons.save_changes')
    expect(page).to have_no_xpath("//input[@name='location[admin_emails][]']")
  end

  scenario 'with 2 admins but one is empty', :js do
    find_link(I18n.t('admin.buttons.add_admin')).click
    fill_in 'location[admin_emails][]', with: 'moncef@samaritanhouse.com'
    find_link(I18n.t('admin.buttons.add_admin')).click
    click_button I18n.t('admin.buttons.save_changes')
    total_admins = all(:xpath, "//input[@name='location[admin_emails][]']")
    expect(total_admins.length).to eq 1
  end
end
