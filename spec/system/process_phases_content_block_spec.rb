# frozen_string_literal: true

require "rails_helper"

describe "Process phases content block" do
  let(:organization) { create(:organization) }
  let(:process) do
    create(
      :participatory_process,
      organization: organization,
      title: { en: "Test process" },
      slug: "test-process"
    )
  end
  let!(:step_one) do
    create(
      :participatory_process_step,
      participatory_process: process,
      title: { en: "Phase 1. Initial proposal" },
      start_date: Date.new(2026, 1, 1),
      end_date: Date.new(2026, 1, 15),
      active: true
    )
  end
  let!(:step_two) do
    create(
      :participatory_process_step,
      participatory_process: process,
      title: { en: "Phase 2. Collaborative review" },
      start_date: Date.new(2026, 1, 16),
      end_date: Date.new(2026, 2, 28)
    )
  end

  before do
    switch_to_host(organization.host)
  end

  context "when the content block is published on the process homepage" do
    before do
      create(
        :content_block,
        organization: organization,
        scope_name: :participatory_process_homepage,
        scoped_resource_id: process.id,
        manifest_name: :process_phases,
        published_at: Time.current
      )
      visit decidim_participatory_processes.participatory_process_path(process)
    end

    it "renders both step titles inline on the page" do
      expect(page).to have_content("Phase 1. Initial proposal")
      expect(page).to have_content("Phase 2. Collaborative review")
    end

    it "renders the section heading from the shared i18n key" do
      expect(page).to have_content(I18n.t("decidim.participatory_process_steps.index.process_steps"))
    end

    it "renders the steps as a numbered list" do
      within("ol.participatory-space__metadata-modal__list") do
        expect(page).to have_css("li", count: 2)
      end
    end
  end

  context "when the content block is not published on the process homepage" do
    before do
      visit decidim_participatory_processes.participatory_process_path(process)
    end

    it "does not render the inline phases section" do
      expect(page).to have_no_css("ol.participatory-space__metadata-modal__list")
    end
  end
end
