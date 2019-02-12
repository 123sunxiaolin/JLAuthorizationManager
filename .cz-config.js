'use strict';

module.exports = {

  types: [
    {value: 'feat',     name: 'feat:     A new feature'},
    {value: 'fix',      name: 'fix:      A bug fix'},
    {value: 'docs',     name: 'docs:     Documentation only changes'},
    {value: 'style',    name: 'style:    Changes that do not affect the meaning of the code'},
    {value: 'refactor', name: 'refactor: A code change that neither fixes a bug nor adds a feature'},
    {value: 'perf',     name: 'perf:     A code change that improves performance'},
    {value: 'pod',      name: 'pod:      Pod update'},
    {value: 'revert',   name: 'revert:   Revert to a commit'},
    {value: 'config',   name: 'config:   Change config file'},
    {value: 'merge',    name: 'merge:    Merge operation'},
    {value: 'test',     name: 'test:     Add Test'},
    {value: 'hoc',      name: 'hoc:      Release Hoc'},
    {value: 'release',  name: 'release:  Release to App Store'},
  ],

  scopes: [
    {name: 'AuthorizationManager'},
    {name: 'Base'},
    {name: 'Camera'},
    {name: 'Microphone'},
    {name: 'Notification'},
    {name: 'Photos'},
    {name: 'CellularNetwork'},
    {name: 'Contact'},
    {name: 'Calendar'},
    {name: 'Reminder'},
    {name: 'Location'},
    {name: 'AppleMusic'},
    {name: 'SpeechRecognizer'},
    {name: 'Siri'},
    {name: 'Motion'},
    {name: 'Bluetooth'},
    {name: 'Health'},
  ],

  // override the messages, defaults are as follows
  messages: {
    type: 'Select the type of change that you\'re committing:',
    scope: '\nDenote the SCOPE of this change (optional):',
    // used if allowCustomScopes is true
    customScope: 'Denote the SCOPE of this change:',
    subject: 'Write a SHORT, IMPERATIVE tense description of the change:\n',
    body: 'Provide a LONGER description of the change (optional). Use "|" to break new line:\n',
    breaking: 'List any BREAKING CHANGES (optional):\n',
    footer: 'List any ISSUES CLOSED by this change (optional). E.g.: #31, #34:\n',
    confirmCommit: 'Are you sure you want to proceed with the commit above?'
  },

  allowCustomScopes: true,
  allowBreakingChanges: ['feat', 'fix']

};
