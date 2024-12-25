
on getDomainFromUrl(urlString)
  set domainString to urlString
  if domainString contains "://" then
    set AppleScript's text item delimiters to "://"
    set domainParts to text items of domainString
    set domainString to item 2 of domainParts
  end if
  
  set AppleScript's text item delimiters to "/"
  set domainParts to text items of domainString
  set domainString to item 1 of domainParts
  
  set AppleScript's text item delimiters to "" -- Reset delimiters
  
  return domainString
end getDomainFromUrl

on run argv
  if (count of argv) is 0 then
    log "Error: Please provide a URL as an argument"
    return
  end if
  
  set websiteURL to item 1 of argv
  set customName to missing value
  if (count of argv) ≥ 2 then
    set customName to item 2 of argv
  end if
  
  set targetDomain to my getDomainFromUrl(websiteURL)
  set maxAttempts to 30 -- Maximum number of 1-second checks
  
  log "Starting to process: " & websiteURL
  log "Target domain: " & targetDomain
  if customName is not missing value then
    log "Custom name: " & customName
  end if
  
  tell application "Safari"
    activate
    open location websiteURL
    
    -- Wait for authentication and proper redirect
    repeat maxAttempts times
      delay 1
      set currentURL to URL of current tab of window 1
      set currentDomain to my getDomainFromUrl(currentURL)
      
      -- TODO: instead of checking domain, assert if "accounts", "login", "auth" in URL and prompt user to login first
      -- Check if we're on a Google auth page
      if currentDomain contains "accounts.google.com" then
        -- TODO: prompt user to login using a macOS prompt instead of a cmd log here
        log "⚠️  Waiting for Google authentication..."
        log "Current URL: " & currentURL
      end if
      
      if currentDomain contains targetDomain then
        log "✅ Reached intended domain: " & currentDomain
        log "Full URL: " & currentURL
        delay 2
        tell application "System Events"
          tell process "Safari"
            click menu item "Add to Dock…" of menu "File" of menu bar 1
            
            log "Waiting for Add to Dock sheet to load..."
            delay 3
            
            -- Verify sheet exists
            if exists sheet 1 of window 1 then
              delay 2
              
              set sheetElements to UI elements of sheet 1 of window 1
              
              if customName is not missing value then
                try
                  set nameField to first text field of group 1 of sheet 1 of window 1
                  set focused of nameField to true
                  delay 0.5
                  keystroke customName
                  log "✅ Set custom name"
                on error errMsg
                  log "⚠️  Could not set custom name: " & errMsg
                end try
              end if
              
              -- Focus the URL field and try to simplify it
              try
                set urlField to last text field of group 1 of sheet 1 of window 1
                set focused of urlField to true
                delay 0.5
                
                -- Press delete key multiple times to try to get to base URL
                repeat 20 times
                  key code 51 -- Delete key
                  delay 0.1
                end repeat
                log "✅ Modified URL field"
              on error errMsg
                log "⚠️  Could not modify URL field: " & errMsg
              end try
              
              delay 3
              
              try
                click button 1 of sheet 1 of window 1
                log "✅ Clicked confirm button"
              on error errMsg
                log "❌ Could not click confirm button: " & errMsg
                error "Failed to click confirm button"
              end try
            else
              log "❌ Add to Dock sheet did not appear"
              error "Sheet not found"
            end if
          end tell
        end tell
        
        tell application "Safari"
          close window 1
        end tell
        
        log "✅ Successfully added " & websiteURL & " to dock"
        return
      end if
      
      log "⏳ Waiting for redirect... Current domain: " & currentDomain
    end repeat
    
    -- If we get here, we never reached the intended domain
    log "❌ Failed to reach " & targetDomain & " after " & maxAttempts & " seconds"
    log "Last URL: " & currentURL
    error "Failed to reach intended domain"
  end tell
end run
