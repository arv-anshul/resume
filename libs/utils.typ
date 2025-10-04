// Helper functions for resume building
// NOT FROM [https://typst.app/universe/package/basic-resume] PROJECT

#let strip-url(url: "") = {
  return url.trim(regex("https?://"), at: start)
}

#let find-profile(profiles, network: "") = {
  return profiles.find(profile => lower(profile.network) == network)
}
