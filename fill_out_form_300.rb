require_relative "./config/boot"

PDF::Form300.generate(App.osha_incidents, year: 2020, location: App.monsters_inc)
