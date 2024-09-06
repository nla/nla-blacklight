# Changelog

## [3.3.0](https://github.com/nla/nla-blacklight/compare/nla-blacklight-v3.4.0...nla-blacklight/3.3.0) (2024-09-06)


### ⚠ BREAKING CHANGES

* upgrade to Blacklight 8
* **solr:** Single document search no longer uses the Blacklight default of /get.

### Features

* add feature flag to disable requesting related features ([1c5b24e](https://github.com/nla/nla-blacklight/commit/1c5b24ed5319ac0c7a033575216f1fd8166b11a3))
* add spacing to “New Catalogue search” button ([afd77d7](https://github.com/nla/nla-blacklight/commit/afd77d78283ebeea6d46318726d49638eef523d1))
* change error for invalid phone/mobile phone ([5d29eab](https://github.com/nla/nla-blacklight/commit/5d29eab7a4e50cc01b06763911dc46f25658e9d4))
* change Github workflow and release-please config ([e507476](https://github.com/nla/nla-blacklight/commit/e507476e44005677ff1de929bc82f903036c0fde))
* disable email 2fa from appearing on profile page ([c22c98e](https://github.com/nla/nla-blacklight/commit/c22c98e53e336bc1a79b0ef63a29640d9f64cf8c))
* disable login during FOLIO updates ([de7358a](https://github.com/nla/nla-blacklight/commit/de7358a17c13020818fb3d8fb3c91194a1f0e492))
* implement email 2fa alert ([a4790de](https://github.com/nla/nla-blacklight/commit/a4790deef59068c1996e23e099eafadae5008ad0))
* implement enabling/disabling of email 2fa from Account Settings ([8e74216](https://github.com/nla/nla-blacklight/commit/8e7421648e17bced73b1729dacac5708b6fa4f58))
* merge main branch and increase test coverage ([a11b7ed](https://github.com/nla/nla-blacklight/commit/a11b7ed516edb795f2703f2823c6209c7f182e53))
* remove unnecessary solr_wrapper rake tasks ([0d99739](https://github.com/nla/nla-blacklight/commit/0d99739d7e22d0cab1dbe234d4c0fe1fa810016f))
* Update Join us link in primary nav ([d63037c](https://github.com/nla/nla-blacklight/commit/d63037c2fe4b2239b3643b52d6bc8d013aa843bb))
* Update login with library card text references ([8515b50](https://github.com/nla/nla-blacklight/commit/8515b50af9cce942dc8a67df088475ed05343719))
* update nla-blacklight_common dependency ([d2223a4](https://github.com/nla/nla-blacklight/commit/d2223a4e678331fb06c3b88b257248018af8e95a))
* update README text ([5e31129](https://github.com/nla/nla-blacklight/commit/5e311290b53fa1091a6783d3a0687af6cbee845a))
* Update request item text ([eb8b605](https://github.com/nla/nla-blacklight/commit/eb8b605a3b0a87b93f589df47a3c63d53d498c22))
* update routes annotation ([ff5a49d](https://github.com/nla/nla-blacklight/commit/ff5a49d2fb8b9b590e96846d86f00e7a5a80c350))
* Update text and image for Join library on homepage ([c7be2a2](https://github.com/nla/nla-blacklight/commit/c7be2a2e13e1a3c257697097e02e420bdacfbdaa))
* Update text message for successful request ([3ab0db6](https://github.com/nla/nla-blacklight/commit/3ab0db679a48cbbd10ad11d4d6e989dc83efc2fb))
* Update twitter icon to X ([e853c79](https://github.com/nla/nla-blacklight/commit/e853c7936c258d3aad22b079806f7040e07eb29f))
* upgrade to Blacklight 8 ([6ce93c1](https://github.com/nla/nla-blacklight/commit/6ce93c156793b589993ff1e50d8aad19cd4069f4))


### Bug Fixes

* add missing rubocop dependencies and fix deprecated syntax ([90b4c59](https://github.com/nla/nla-blacklight/commit/90b4c599aaf1db4e2d31f06101b1a20d4a93e6a9))
* add placeholders for validation messages ([0aed38d](https://github.com/nla/nla-blacklight/commit/0aed38d707c51ed73290e4d0a08e2a2a72a68f8b))
* align labels on tablet view ([4f519bb](https://github.com/nla/nla-blacklight/commit/4f519bbb5d9b0fde5c6f73a289c532d805215fa8))
* bump dotenv and prevent frozen hash issue ([508740d](https://github.com/nla/nla-blacklight/commit/508740d971927926be14d8d1b98c957b1c115545))
* change link to join us page ([421885b](https://github.com/nla/nla-blacklight/commit/421885b53f75c8650d01d88003a4c797ee271c7a))
* change pub_date_ssim to pub_date_si ([80b5369](https://github.com/nla/nla-blacklight/commit/80b5369af9f2f6325777a025a703cfda5a594c00))
* change request alert wording ([7c0c5eb](https://github.com/nla/nla-blacklight/commit/7c0c5eb0178e500e67c5a72624ba67c447253ab3))
* comment out active_storage from production env config ([ad0db78](https://github.com/nla/nla-blacklight/commit/ad0db7833192b842b988aa7ba744c8b866c69c17))
* configure correct Solr search adapter in blacklight.yml ([e90e0f5](https://github.com/nla/nla-blacklight/commit/e90e0f5b165508a4467b768181ddb674845d58ec))
* display record title instead of eResource title ([c64de08](https://github.com/nla/nla-blacklight/commit/c64de084695c45178bbfe0384f94f1c34a25cfe1))
* downgrade postcss-cli npm dependency ([acc1f7f](https://github.com/nla/nla-blacklight/commit/acc1f7fa7ba0070de93a78d7550d546512c78837))
* fix logout link ([b7ce8b2](https://github.com/nla/nla-blacklight/commit/b7ce8b2a0aa576d5584d9dd4288179f341247620))
* fix missed renamed method calls ([fd723d1](https://github.com/nla/nla-blacklight/commit/fd723d1e9f69090464bad25cf9942aa01cbfc3b7))
* fix nla-blacklight_common dependency path ([93316c0](https://github.com/nla/nla-blacklight/commit/93316c006e0d94941ee620e169e6f13bc401ea65))
* fix scrollbar styling on Blacklight modal ([c19eb86](https://github.com/nla/nla-blacklight/commit/c19eb861252a3dd962b1d8229ab196d956565152))
* fix styling of blacklight range limit plugin ([d0c383b](https://github.com/nla/nla-blacklight/commit/d0c383b51a7e08b465d3f5c7a2557eec162e7012))
* ignore Brakeman false positives and handle UnsafeRedirectError ([3c681ae](https://github.com/nla/nla-blacklight/commit/3c681ae9f26a14122decfeb1751d523fe0859077))
* improve modal styles ([bb16481](https://github.com/nla/nla-blacklight/commit/bb16481f4cb93cc81d134ba3fd14f2f122476f35))
* include issn in Trove search query ([adff326](https://github.com/nla/nla-blacklight/commit/adff3264eef0573639b7264350881d0bad0b1b30))
* increase email field length to max length in Keycloak ([2da5651](https://github.com/nla/nla-blacklight/commit/2da5651426bb9ed4721e2124de2c52c39607cc18))
* isolate validation of user settings ([1f44de6](https://github.com/nla/nla-blacklight/commit/1f44de6195c7fb03674d87e737a62bee400346a2))
* login page error for non-existent document ([446b1da](https://github.com/nla/nla-blacklight/commit/446b1da6764d080d6a905c2305e9137454fd007e))
* Make image card tiles on homepage equal height ([4b72497](https://github.com/nla/nla-blacklight/commit/4b72497752e36fa7b669c6a0fae72260cd667e0f))
* mark mandatory field with star and reformat maps metadata ([5f5ccf9](https://github.com/nla/nla-blacklight/commit/5f5ccf9fcdb9e3c97e59e80bf0f1e20d05b797be))
* override onFailure method of Blacklight modal ([9a71666](https://github.com/nla/nla-blacklight/commit/9a716667a3e5717c03d7ffcff6c7af257c7b61b7))
* Print modal dialog over multiple pages ([3c9d381](https://github.com/nla/nla-blacklight/commit/3c9d3810b392ade918df207e3a174bf8defa8b30))
* pull in change to add /logout route ([4ab5fad](https://github.com/nla/nla-blacklight/commit/4ab5fad5edfd243240f785158b9741cd6fc2e227))
* reapply print styles made in deprecated views ([64a3870](https://github.com/nla/nla-blacklight/commit/64a3870868fad94c4a1c0219a142d064de1ef6be))
* remove deprecated response from search service ([f4d888c](https://github.com/nla/nla-blacklight/commit/f4d888c1d972e744e3a935c889f12a83f20beca8))
* remove limit from language facet ([d71631e](https://github.com/nla/nla-blacklight/commit/d71631e148c448541dd3702ced4d8f255fc9cfd6))
* replace deprecated Bootstrap styles ([74ae599](https://github.com/nla/nla-blacklight/commit/74ae599875c27e3ad5f6664108d2d599ae84d6bb))
* resolve Rubocop errors ([baa7934](https://github.com/nla/nla-blacklight/commit/baa79340853863f0e8dd5e12cf603aab6f150c7b))
* restyle forms for Bootstrap 5 compatibility ([ef1d267](https://github.com/nla/nla-blacklight/commit/ef1d267b9d7ba98e2e511cf81827b9db605bd4fb))
* set headers to not cache any pages ([e0fce88](https://github.com/nla/nla-blacklight/commit/e0fce8870001c5268c6f86da900c1d8f65c48e6a))
* set json_solr_path to nil to prevent advanced search error ([bc560d2](https://github.com/nla/nla-blacklight/commit/bc560d239a2241bda013f8a1a802ff398955b7ab))
* set print styles ([7dbc483](https://github.com/nla/nla-blacklight/commit/7dbc4832a79b2103befa4ab6e962f3d19bffaa68))
* setting user details during edit ([8cf8e4a](https://github.com/nla/nla-blacklight/commit/8cf8e4a4baccb9f0bd256bea98b345619c5edec3))
* **solr:** use /select for single document search ([31a45a7](https://github.com/nla/nla-blacklight/commit/31a45a759051503cff47e8abad1212cf68787670))
* staff password is not editable ([9eac8ad](https://github.com/nla/nla-blacklight/commit/9eac8ad86e927270eac9f3ccc997a62ff8890a4b))
* style blacklight range limit modal graph ([0213afd](https://github.com/nla/nla-blacklight/commit/0213afd8db4279757f0f97eca7a9e7addb469ba1))
* turn of caching in test ([2d93d72](https://github.com/nla/nla-blacklight/commit/2d93d729112d258ca1ce580e7739454c6c7d3ff8))
* uncomment call to catalogue services to make reqeust ([06c6837](https://github.com/nla/nla-blacklight/commit/06c6837d6512376f67aeb6a15fdf63630f2fe43a))
* update spacing CSS classes for bootstrap 5 ([cf7c7ae](https://github.com/nla/nla-blacklight/commit/cf7c7aee96582919c41e90ab18dc8b73f060c964))
* update vulnerable dependencies ([20b9c95](https://github.com/nla/nla-blacklight/commit/20b9c95f198339fca6e4b3211f3b657a9e296eb7))


### Reverts

* no need to customise DocumentComponent ([a87be61](https://github.com/nla/nla-blacklight/commit/a87be61ab4d8679c92042d5a35f7862869cab013))
* reverse ip lookup change ([d50085d](https://github.com/nla/nla-blacklight/commit/d50085d8fe1a125bfcf5ea6099b0fc02ac1578d0))
* revert disabling of email 2FA ([3ea8aae](https://github.com/nla/nla-blacklight/commit/3ea8aaeb8ad35b95ae280bdde7a3ec121a979656))
* revert removal of solr_wrapper rake task ([fa54c03](https://github.com/nla/nla-blacklight/commit/fa54c039343347f9a8a03eb042b6c28a24ff9a80))
* rollback per page of catalogue results in bento search ([8c67cd8](https://github.com/nla/nla-blacklight/commit/8c67cd87b1e8bf86ae6345e4644c02a3d12eebd8))


### Miscellaneous

* bump nodejs dependencies ([2ef31f1](https://github.com/nla/nla-blacklight/commit/2ef31f138a919e2213e12605972c617b357e1b67))
* cherry BLAC-723 hotfix changes ([92a961e](https://github.com/nla/nla-blacklight/commit/92a961e5f63983b1dcdd09691262dd5774cc1b92))
* cherry BLAC-723 hotfix changes - rubocop fix ([ab102c4](https://github.com/nla/nla-blacklight/commit/ab102c4d4c342f4e80c5e0ba2629cb9edbce1836))
* cherry BLAC-723 hotfix changes - update rexml version ([f9a2f97](https://github.com/nla/nla-blacklight/commit/f9a2f9730decee2de06cd750d322a9d5b1505aab))
* clean up JS console logging ([692e8fb](https://github.com/nla/nla-blacklight/commit/692e8fb735f97f45b58519455875f4aaff051c95))
* **deps-dev:** bump binding_of_caller from 1.0.0 to 1.0.1 ([ac7f9e4](https://github.com/nla/nla-blacklight/commit/ac7f9e44530ab9a78a6941b12238b06b3d5f41fc))
* **deps-dev:** bump capybara from 3.39.2 to 3.40.0 ([2a019f2](https://github.com/nla/nla-blacklight/commit/2a019f2913f7e7f8b20d83028d1794a17a7c536a))
* **deps-dev:** bump cuprite from 0.14.3 to 0.15 ([b2a2e26](https://github.com/nla/nla-blacklight/commit/b2a2e26e0462c0a6d120f4d6eec48567bc5a3b51))
* **deps-dev:** bump cuprite from 0.15 to 0.15.1 ([0432cc9](https://github.com/nla/nla-blacklight/commit/0432cc91a4b07f3c08f2e5d9b5e83d1658c3b5ec))
* **deps-dev:** bump debug from 1.8.0 to 1.9.2 ([b898dac](https://github.com/nla/nla-blacklight/commit/b898daca05f458cab21e1adad7bf201fd1324e46))
* **deps-dev:** bump dotenv from 3.0.3 to 3.1.2 ([f6c6f86](https://github.com/nla/nla-blacklight/commit/f6c6f86ce0f7733fd662d0c59c6b9540bb2f5b51))
* **deps-dev:** bump factory_bot_rails from 6.4.2 to 6.4.3 ([11dc586](https://github.com/nla/nla-blacklight/commit/11dc5863b512514f1f044a05fc82f9f44765533a))
* **deps-dev:** bump faker from 3.2.2 to 3.2.3 ([be2d44f](https://github.com/nla/nla-blacklight/commit/be2d44fab97464d7b4452e0134f8fdeb82b0ab5c))
* **deps-dev:** bump faker from 3.4.1 to 3.4.2 ([7ef058a](https://github.com/nla/nla-blacklight/commit/7ef058ac47138e4827d4a21d69f87504adba8900))
* **deps-dev:** bump mock_redis from 0.37.0 to 0.39.0 ([f37e083](https://github.com/nla/nla-blacklight/commit/f37e0836bad1e598336711ef6a6bfabba4fde3c6))
* **deps-dev:** bump mock_redis from 0.39.0 to 0.44.0 ([4f7f61a](https://github.com/nla/nla-blacklight/commit/4f7f61a0ba78e518fe7f4aac0d054fa755d294a2))
* **deps-dev:** bump rack-mini-profiler from 3.1.1 to 3.3.1 ([1512174](https://github.com/nla/nla-blacklight/commit/1512174e0316840bab7ae1cf2c4e83a4c596a090))
* **deps-dev:** bump rdoc from 6.6.0 to 6.7.0 ([6bbd5c5](https://github.com/nla/nla-blacklight/commit/6bbd5c59c6f9049be3822574e6f948ccc4e2a524))
* **deps-dev:** bump rspec-rails from 6.1.0 to 6.1.2 ([cb3de71](https://github.com/nla/nla-blacklight/commit/cb3de71d28b985fd903ac4c5f1027e9ad7058027))
* **deps-dev:** bump rspec-rails from 6.1.3 to 6.1.4 ([956c837](https://github.com/nla/nla-blacklight/commit/956c837c5a7976863589743eba61f965a08b0c55))
* **deps-dev:** bump rubocop-rails from 2.23.1 to 2.25.0 ([008d556](https://github.com/nla/nla-blacklight/commit/008d55658952b0cf644b3ee071e7caf58e748779))
* **deps-dev:** bump rubocop-rspec from 2.24.1 to 2.25.0 ([e2bed18](https://github.com/nla/nla-blacklight/commit/e2bed185cb958a9a45789305c9204c492c614a30))
* **deps-dev:** bump rubocop-rspec from 2.25.0 to 3.0.1 ([c78785b](https://github.com/nla/nla-blacklight/commit/c78785b3a644865aee5a2e067f5bb1a61540fc34))
* **deps-dev:** bump rubocop-rspec from 2.25.0 to 3.0.1 ([71de305](https://github.com/nla/nla-blacklight/commit/71de30537c6737fb6e9b185c1569c8571a628e85))
* **deps-dev:** bump rubocop-rspec from 3.0.3 to 3.0.4 ([0ab9487](https://github.com/nla/nla-blacklight/commit/0ab94872de0f6dc8f824b36380d9729f822bc9c9))
* **deps-dev:** bump selenium-webdriver from 4.14.0 to 4.15.0 ([c5a762e](https://github.com/nla/nla-blacklight/commit/c5a762efbfdb532505a2279c2d8698e4a915e7fa))
* **deps-dev:** bump selenium-webdriver from 4.15.0 to 4.17.0 ([29f4825](https://github.com/nla/nla-blacklight/commit/29f4825b47f9f41407037092d59b612c5d033dbe))
* **deps-dev:** bump selenium-webdriver from 4.17.0 to 4.21.1 ([93ba44c](https://github.com/nla/nla-blacklight/commit/93ba44c5483d16d366449ea8d0ed44072fb03eaf))
* **deps-dev:** bump selenium-webdriver from 4.21.1 to 4.22.0 ([5dcbdd9](https://github.com/nla/nla-blacklight/commit/5dcbdd99323497f0479e449ff3019bf3858e264f))
* **deps-dev:** bump selenium-webdriver from 4.22.0 to 4.23.0 ([4ac2747](https://github.com/nla/nla-blacklight/commit/4ac274790b4769a9f730c4703ad7a7eab436d6e4))
* **deps-dev:** bump shoulda-matchers from 5.3.0 to 6.2.0 ([f5313b4](https://github.com/nla/nla-blacklight/commit/f5313b46a50f4f9264e11a6ff5db2e9c624c17b9))
* **deps-dev:** bump shoulda-matchers from 6.2.0 to 6.4.0 ([8373d49](https://github.com/nla/nla-blacklight/commit/8373d49ce3afb3f5326e3ba7816b36196004870d))
* **deps-dev:** bump stackprof from 0.2.25 to 0.2.26 ([bd00f86](https://github.com/nla/nla-blacklight/commit/bd00f868ad0bb290b6c5bf274288b3f748aff502))
* **deps-dev:** bump standard and rubocop-performance ([c492b84](https://github.com/nla/nla-blacklight/commit/c492b84f4b9489205a87f7372d3995aea7b43d12))
* **deps-dev:** bump standard from 1.33.0 to 1.39.0 ([1793c3d](https://github.com/nla/nla-blacklight/commit/1793c3d54b8e8ed10d63fa75b2f49c44dfc2587f))
* **deps-dev:** bump webmock from 3.19.1 to 3.23.0 ([9b1f44e](https://github.com/nla/nla-blacklight/commit/9b1f44e7439914ba27ac7d05f0aae64337657521))
* **deps:** bump @hotwired/turbo-rails from 7.3.0 to 8.0.4 ([8482ab0](https://github.com/nla/nla-blacklight/commit/8482ab0ead24de503a919b2a32be869d6edb8c0d))
* **deps:** bump @hotwired/turbo-rails from 8.0.4 to 8.0.5 ([799dcb2](https://github.com/nla/nla-blacklight/commit/799dcb2c9f969a458481fbd169d5dcdebbfa0ce6))
* **deps:** bump actionpack from 7.0.8.3 to 7.0.8.4 ([64a73ce](https://github.com/nla/nla-blacklight/commit/64a73ce8d6c9218be1660ba87ce4f5101d19b415))
* **deps:** bump autoprefixer from 10.4.17 to 10.4.19 ([b4fe092](https://github.com/nla/nla-blacklight/commit/b4fe0921bb5dc0d310c72b098f1bfee945ad0297))
* **deps:** bump autoprefixer from 10.4.19 to 10.4.20 ([178a765](https://github.com/nla/nla-blacklight/commit/178a7659a9d37351bbfb621cd17cce21eec66c40))
* **deps:** bump blacklight from 7.34.0 to 7.35.0 ([c6cdf4b](https://github.com/nla/nla-blacklight/commit/c6cdf4b01e657790286e1ceef84497bb5ec6f6e7))
* **deps:** bump blacklight_range_limit from 8.3.0 to 8.4.0 ([d375a25](https://github.com/nla/nla-blacklight/commit/d375a25b60ddb23ae908a0f55487b85084f32c75))
* **deps:** bump blacklight-frontend from 8.0.1 to 8.3.0 ([713344c](https://github.com/nla/nla-blacklight/commit/713344c3d7f0b052588347d96a60dcdf5219400a))
* **deps:** bump blacklight-marc from 8.1.3 to 8.1.4 ([8a614a5](https://github.com/nla/nla-blacklight/commit/8a614a5f5ee2da3aaa5682fa91b0ac68ea0b8819))
* **deps:** bump bootsnap from 1.16.0 to 1.17.0 ([0fb254e](https://github.com/nla/nla-blacklight/commit/0fb254e9e572c5c1e3c90536a620f1480aa42998))
* **deps:** bump bootsnap from 1.17.0 to 1.18.3 ([326eb41](https://github.com/nla/nla-blacklight/commit/326eb41da0210c043ec1e96ae40828f79049a04e))
* **deps:** bump bootsnap from 1.18.3 to 1.18.4 ([c095b84](https://github.com/nla/nla-blacklight/commit/c095b8438cf602de2d8213a168603529d74ecf7f))
* **deps:** bump braces from 3.0.2 to 3.0.3 ([da06086](https://github.com/nla/nla-blacklight/commit/da060869b79f658a2bb2c613724a4f0a949ba4f2))
* **deps:** bump brakeman from 6.1.2 to 6.2.1 ([ecc0918](https://github.com/nla/nla-blacklight/commit/ecc09186d074c156a62ff3f4a73c1377fa502f34))
* **deps:** bump bundler-audit from 0.9.1 to 0.9.2 ([19d248a](https://github.com/nla/nla-blacklight/commit/19d248a0d32ece86e31e8a7a889a34e519d7c09f))
* **deps:** bump cssbundling-rails from 1.3.3 to 1.4.0 ([3862885](https://github.com/nla/nla-blacklight/commit/3862885d89d68cb7922797ff5ba585fc7143f281))
* **deps:** bump cssbundling-rails from 1.4.0 to 1.4.1 ([8e580d0](https://github.com/nla/nla-blacklight/commit/8e580d0d56e50e01c580523291a0258a11c986c0))
* **deps:** bump esbuild from 0.19.2 to 0.20.0 ([9247f41](https://github.com/nla/nla-blacklight/commit/9247f41e188d619bc1f35960110097c1212153c2))
* **deps:** bump esbuild from 0.20.0 to 0.21.4 ([553d761](https://github.com/nla/nla-blacklight/commit/553d7616ac461a6e84889616a30a1bc6e28ff64c))
* **deps:** bump esbuild from 0.21.4 to 0.21.5 ([40feac3](https://github.com/nla/nla-blacklight/commit/40feac31beb4f75b7f40ff633d1dd88df5cdc666))
* **deps:** bump esbuild from 0.21.5 to 0.23.0 ([251f913](https://github.com/nla/nla-blacklight/commit/251f91341cba8e7d70bd317e563e390a0a631236))
* **deps:** bump esbuild from 0.23.0 to 0.23.1 ([2bb1623](https://github.com/nla/nla-blacklight/commit/2bb1623cbd0ec2d677e7c6157d90ab201a248569))
* **deps:** bump fugit from 1.11.0 to 1.11.1 ([cb33847](https://github.com/nla/nla-blacklight/commit/cb338471debd7ee439b8cff8ec04ed59a28119ff))
* **deps:** bump google-github-actions/release-please-action ([f9d2215](https://github.com/nla/nla-blacklight/commit/f9d2215939afd22f14c33a06d32595d928d4c2c5))
* **deps:** bump hiredis-client from 0.17.1 to 0.18.0 ([f701a89](https://github.com/nla/nla-blacklight/commit/f701a8917f62afec13ea780d3c013e2b083e4b33))
* **deps:** bump hiredis-client from 0.18.0 to 0.22.2 ([aad37e4](https://github.com/nla/nla-blacklight/commit/aad37e415e45a080e7f09186b9cf89e29b457e6b))
* **deps:** bump importmap-rails from 1.2.1 to 1.2.3 ([ac4f2b1](https://github.com/nla/nla-blacklight/commit/ac4f2b17919bdc69233010a5a45cabfcb96d346f))
* **deps:** bump jsbundling-rails from 1.3.0 to 1.3.1 ([82c148f](https://github.com/nla/nla-blacklight/commit/82c148fe8cc84bf23cbd4a7402186d73d4a910ee))
* **deps:** bump micromatch from 4.0.5 to 4.0.8 ([0302d8a](https://github.com/nla/nla-blacklight/commit/0302d8a9ec7b30dbc56911e7f01f524a891f13bb))
* **deps:** bump mysql2 from 0.5.5 to 0.5.6 ([df73ca8](https://github.com/nla/nla-blacklight/commit/df73ca87a6af3e877ec7f76238616474922ee4f8))
* **deps:** bump nla-blacklight_common from `90d3271` to `9074700` ([1916b91](https://github.com/nla/nla-blacklight/commit/1916b91dfbc4da9129f33429623f00ef22fc0ae4))
* **deps:** bump nla-blacklight_common from `c0c44e3` to `90d3271` ([30d6a3c](https://github.com/nla/nla-blacklight/commit/30d6a3c4ad6030632525b5ae8bae33d735386694))
* **deps:** bump nodemon from 3.0.1 to 3.0.3 ([8d55613](https://github.com/nla/nla-blacklight/commit/8d55613ee3cee6c61150fb547b627f3110e6b844))
* **deps:** bump nodemon from 3.0.3 to 3.1.0 ([bc69950](https://github.com/nla/nla-blacklight/commit/bc69950f6ca57ee9ceab1cccb3764c56f7ae8308))
* **deps:** bump nodemon from 3.1.0 to 3.1.2 ([863f38e](https://github.com/nla/nla-blacklight/commit/863f38e595d58d75b75f09a7b2b7e36623517a25))
* **deps:** bump nodemon from 3.1.2 to 3.1.3 ([ea4ef76](https://github.com/nla/nla-blacklight/commit/ea4ef764edf56449d225d06c186cf67e995bf61e))
* **deps:** bump nodemon from 3.1.3 to 3.1.4 ([2e0810a](https://github.com/nla/nla-blacklight/commit/2e0810a4d20af3ed9e3e92a877acd691073721b9))
* **deps:** bump nokogiri from 1.16.0 to 1.16.2 ([ef393c4](https://github.com/nla/nla-blacklight/commit/ef393c47f1b8d6b6c7c07879ffe74d2d4f600eb6))
* **deps:** bump phonelib from 0.8.5 to 0.8.9 ([e2b872d](https://github.com/nla/nla-blacklight/commit/e2b872d3860d849df2bdb817072ffae3661d55dd))
* **deps:** bump phonelib from 0.8.9 to 0.9.1 ([2ba1745](https://github.com/nla/nla-blacklight/commit/2ba174540e2801db210fd2ee664753a645a16516))
* **deps:** bump postcss from 8.4.29 to 8.4.31 ([6ccbfe2](https://github.com/nla/nla-blacklight/commit/6ccbfe25fbf3cc9d9656753a63b07b638bae09e6))
* **deps:** bump postcss from 8.4.29 to 8.4.33 ([301fac0](https://github.com/nla/nla-blacklight/commit/301fac0113a2c76d64da28e92fdeeeee4649e162))
* **deps:** bump postcss from 8.4.33 to 8.4.38 ([fb58776](https://github.com/nla/nla-blacklight/commit/fb58776cb0063ee2aa9568453cc2186b82a31a81))
* **deps:** bump postcss from 8.4.38 to 8.4.40 ([2fdfdcd](https://github.com/nla/nla-blacklight/commit/2fdfdcd9d47579e1e7f784e4f18ca5d4b5d1cc4d))
* **deps:** bump postcss from 8.4.40 to 8.4.41 ([0459bb3](https://github.com/nla/nla-blacklight/commit/0459bb337cf9b19a5290b625b6665c912ac71c72))
* **deps:** bump postcss-cli from 10.1.0 to 11.0.0 ([55100be](https://github.com/nla/nla-blacklight/commit/55100be96413a941501bb7e6c3d9885e0aca547a))
* **deps:** bump redis from 5.0.7 to 5.0.8 ([01646f4](https://github.com/nla/nla-blacklight/commit/01646f44b94bd21aea6184d5be160327b8f833d7))
* **deps:** bump redis from 5.0.8 to 5.2.0 ([15d1e59](https://github.com/nla/nla-blacklight/commit/15d1e59cb87d7bfdf6b1dc76ce5275c133202743))
* **deps:** bump redis from 5.2.0 to 5.3.0 ([2035046](https://github.com/nla/nla-blacklight/commit/2035046c70a206c5751a6291642feb38b61a3b0a))
* **deps:** bump rexml from 3.2.6 to 3.2.8 ([4ee2f9b](https://github.com/nla/nla-blacklight/commit/4ee2f9b834b33708297b2a405500f8a69d45c08b))
* **deps:** bump rexml from 3.3.2 to 3.3.3 ([56b625c](https://github.com/nla/nla-blacklight/commit/56b625c900a8b411fd61640c416ed3ce65991158))
* **deps:** bump rexml from 3.3.3 to 3.3.6 ([8677726](https://github.com/nla/nla-blacklight/commit/8677726630ff986c2870fdd8a0e9ca22ce5e5342))
* **deps:** bump sass from 1.71.1 to 1.77.4 ([4455ad0](https://github.com/nla/nla-blacklight/commit/4455ad0cfb6bec4bb133b400deb7878e5a1c86b2))
* **deps:** bump sass from 1.77.4 to 1.77.6 ([782fe0c](https://github.com/nla/nla-blacklight/commit/782fe0cd88aa2d60cbff7c3468aadeb5b25d9c1d))
* **deps:** bump sass from 1.77.6 to 1.77.8 ([4e0c6e2](https://github.com/nla/nla-blacklight/commit/4e0c6e22657beb868ef46b8816418dd29c0d82fb))
* **deps:** bump sprockets-rails from 3.5.1 to 3.5.2 ([f862757](https://github.com/nla/nla-blacklight/commit/f8627576cddaf14a4f0383456120989a94703b31))
* **deps:** bump stimulus-rails from 1.3.0 to 1.3.3 ([0720cbf](https://github.com/nla/nla-blacklight/commit/0720cbf914bdf8544e3b81926c5040457a15f789))
* **deps:** bump stimulus-rails from 1.3.3 to 1.3.4 ([f920b04](https://github.com/nla/nla-blacklight/commit/f920b0400b04640c364b59b0e65219742f72ddc7))
* **deps:** bump strong_migrations from 1.6.4 to 1.7.0 ([e086f40](https://github.com/nla/nla-blacklight/commit/e086f401990abbb53238da609231cb2f6f1b4d16))
* **deps:** bump strong_migrations from 1.7.0 to 1.8.0 ([79e3f74](https://github.com/nla/nla-blacklight/commit/79e3f740eae0edbbf5a69e475736cd6f12a773f4))
* **deps:** bump strong_migrations from 1.8.0 to 2.0.0 ([c4fa7d3](https://github.com/nla/nla-blacklight/commit/c4fa7d3a2c71b0ad46bd22073d76bed6be57f306))
* **deps:** bump turbo-rails from 1.5.0 to 2.0.5 ([be17caf](https://github.com/nla/nla-blacklight/commit/be17cafc0d7945fc6c65ca9101d3944cd16fa301))
* **deps:** bump turbo-rails from 2.0.5 to 2.0.6 ([02f1e41](https://github.com/nla/nla-blacklight/commit/02f1e4133565a86082d71ca45c0cca2b43ab4bcf))
* **deps:** bump yabeda-prometheus from 0.9.0 to 0.9.1 ([940bea1](https://github.com/nla/nla-blacklight/commit/940bea162d8784e22312909b7ca710b0638037a4))
* **main:** release 2.10.0 ([1a04498](https://github.com/nla/nla-blacklight/commit/1a04498c717014d0e63a3ce3ebf6ce6118325b90))
* **main:** release 2.11.0 ([1adc001](https://github.com/nla/nla-blacklight/commit/1adc001fab6e2fd7f5b736afb5133fdb009aabf1))
* **main:** release 2.11.1 ([b7245c0](https://github.com/nla/nla-blacklight/commit/b7245c0cbfba91e30f6252463c77e7e62cad9603))
* **main:** release 3.0.0 ([a577ea1](https://github.com/nla/nla-blacklight/commit/a577ea1437611b30b7e6d902ccd5d5b86d85307e))
* **main:** release 3.1.0 ([3aac3a2](https://github.com/nla/nla-blacklight/commit/3aac3a2789c4cc1fd6940342c6042a8d141afc10))
* **main:** release 3.2.0 ([f3ade93](https://github.com/nla/nla-blacklight/commit/f3ade93168185ad34ffbe2fb31b0ac00e5fa3660))
* **main:** release nla-blacklight 3.2.1 ([ea6ce95](https://github.com/nla/nla-blacklight/commit/ea6ce95716dca8e097672f68c4e19fc866fa6329))
* **main:** release nla-blacklight 3.3.0 ([1d1a83d](https://github.com/nla/nla-blacklight/commit/1d1a83d1a56afa41bd9d198f4ad73b0b4a7b4587))
* **main:** release nla-blacklight 3.3.1 ([7a0dd56](https://github.com/nla/nla-blacklight/commit/7a0dd56eae6dfb5fbc02a7789fa6f79f128bd8e8))
* merge from main ([555a7eb](https://github.com/nla/nla-blacklight/commit/555a7ebf105a483e5b8d78829506acaddd1dd612))
* merge from main branch and fix tests ([3ffc00a](https://github.com/nla/nla-blacklight/commit/3ffc00ad27bc3f14db861ac4028811391c062f19))
* merge main branch ([dc4f5a8](https://github.com/nla/nla-blacklight/commit/dc4f5a8809ca678c388fbd1671984e44d197ecc8))
* merge main branch ([00c2564](https://github.com/nla/nla-blacklight/commit/00c2564a92abeb198cbe36355137bff1f074cea1))
* prepare 3.0.0 release ([58a5c2f](https://github.com/nla/nla-blacklight/commit/58a5c2f230553581d0d871fd85db2317d3d840cf))
* prepare for release ([081e65b](https://github.com/nla/nla-blacklight/commit/081e65b3a04ef82130dc726d11e1641a876c98c4))
* prepare for release ([223f82a](https://github.com/nla/nla-blacklight/commit/223f82a7e465354a1e836cf8afd3c34f65f3d992))
* prepare release ([a2f4ff3](https://github.com/nla/nla-blacklight/commit/a2f4ff3abd7876f0601d2880927eb8ba6cef0c93))
* prepare release ([10827fb](https://github.com/nla/nla-blacklight/commit/10827fb72e4ab10e1b19880f0192899d6ea5542d))
* pull in backchannel logout changes ([08648bb](https://github.com/nla/nla-blacklight/commit/08648bbfec3fa89aa099e4eeebfa51d5bfd0e793))
* pull in changes from nla-blacklight_common ([cd4aec7](https://github.com/nla/nla-blacklight/commit/cd4aec785b105c121000ab0505fd1be22f8ad492))
* pull in changes in common code ([f0f93ea](https://github.com/nla/nla-blacklight/commit/f0f93eaccbf6fc60345c2112464f33aadb4b7ae7))
* pull in changes to login page text ([1a217c4](https://github.com/nla/nla-blacklight/commit/1a217c4a0336fda9e1c6f0786be469e906e749e8))
* pull in fixes to session_token ([e4f2013](https://github.com/nla/nla-blacklight/commit/e4f201360783e74c7f8f916985f344a1d7c229ec))
* release 3.2.0 ([a38cd66](https://github.com/nla/nla-blacklight/commit/a38cd66c5d6a3e45b0121d2fbfe0c772ec973de9))
* release 3.2.1 ([6d80e54](https://github.com/nla/nla-blacklight/commit/6d80e54f2eb240ec5a0a916cdedb172c1439ed68))
* release 3.3.0 ([a47df34](https://github.com/nla/nla-blacklight/commit/a47df3453c453f149f884c18427419e4d0d53e37))
* remove keycloak patron flag ([37c6d99](https://github.com/nla/nla-blacklight/commit/37c6d99e6ed873baec5dfc0209a7128bf685df7b))
* resolve merge collission ([d493569](https://github.com/nla/nla-blacklight/commit/d493569e08d517cbb0c8cb5308476e5c0e01d53a))
* resolve merge conflicts ([0410baf](https://github.com/nla/nla-blacklight/commit/0410baf28bf64830973b9b5392e32712a0934395))
* resolve merge conflicts ([e3e1416](https://github.com/nla/nla-blacklight/commit/e3e1416a5623cf228a19c271143cda73fc00ce64))
* update bundler version ([ae6f6ad](https://github.com/nla/nla-blacklight/commit/ae6f6ad670af949ea2976c05fea7553e23ac92b0))
* update nla-blacklight_common ([fbc6c20](https://github.com/nla/nla-blacklight/commit/fbc6c209f399c018cff76f7d4c1eba4f907c074f))
* update nla-blacklight_common dependency ([a283767](https://github.com/nla/nla-blacklight/commit/a283767e560ae0dee135f2065fc304c3099e75d4))
* update nla-blacklight_common dependency ([22d3f32](https://github.com/nla/nla-blacklight/commit/22d3f326ff40ee3f815ef26c3c2f10f576e6759c))
* update nla-blacklight_common dependency ([b4883bf](https://github.com/nla/nla-blacklight/commit/b4883bf656a7893b45843052b1f631f529a178bd))
* update nla-blacklight_common dependency ([163cfe9](https://github.com/nla/nla-blacklight/commit/163cfe9eedc6d7e9dcea874d137d64d7ec2fb23c))
* update nla-blacklight_common dependency ([fe223f6](https://github.com/nla/nla-blacklight/commit/fe223f65b4f42c97fdd3e33a878b5ecc5c5f6f38))
* update nla-blacklight_common dependency and config examples ([ab62de2](https://github.com/nla/nla-blacklight/commit/ab62de2d915975bd8c1ad863c105f8a57d4a8722))
* update version of nla-blacklight_common ([6841109](https://github.com/nla/nla-blacklight/commit/684110922609fdc67c5b647190cebf59fc55405a))
* upgrade dependencies ([1ea8f9f](https://github.com/nla/nla-blacklight/commit/1ea8f9f87d71164b2fae5642ea7ba7ffefc81398))
* upgrade dependencies ([0b0c9e3](https://github.com/nla/nla-blacklight/commit/0b0c9e331323edfe481b208828c6f3c3d00ca4b2))
* upgrade nl-blacklight_common dependency ([9c92016](https://github.com/nla/nla-blacklight/commit/9c920169b5ad772b6a032a59518bc346f2834361))
* upgrade nla-blacklight_common dependency ([ecf0967](https://github.com/nla/nla-blacklight/commit/ecf09670eb7aab06ee1b06d64c322e0457b6236c))


### Code Refactoring

* get collection names from Solr response instead of MARC ([9f05cf9](https://github.com/nla/nla-blacklight/commit/9f05cf9adbbcea707d0248e4b93d704e9e514ff7))
* link directly to Copies Direct instead of submitting form ([794c505](https://github.com/nla/nla-blacklight/commit/794c505edf4e3b7c609b368995631a01215d0fea))
* move global message render to a common location ([6fbe591](https://github.com/nla/nla-blacklight/commit/6fbe59194906fe2b002c257e6f2a7496deaddf45))
* pull in changes to staff login button style ([cd2f659](https://github.com/nla/nla-blacklight/commit/cd2f659165be060337303bab4b3e6da71bfe0151))
* rename account "settings" to 'profile" ([b0e83a6](https://github.com/nla/nla-blacklight/commit/b0e83a6074521311f70e4344788529b89c3f54ce))
* rename profile strong params methods ([e9b0e81](https://github.com/nla/nla-blacklight/commit/e9b0e81fc077285bf1107a494c332b25558046c5))


### Tests

* fix search service mock to return correct response format ([9148cca](https://github.com/nla/nla-blacklight/commit/9148ccafca171b73b914ee7035ed53744b19dde4))
* fix tests ([f385ca8](https://github.com/nla/nla-blacklight/commit/f385ca8f30710639e1b3c3c438fa2b2373dd53c4))
* refactor request summary system spec ([a7174d4](https://github.com/nla/nla-blacklight/commit/a7174d4d9fc397d108eee2f338e355b00a06cbdd))
* update mobile/phone tests ([90483ca](https://github.com/nla/nla-blacklight/commit/90483cae93a3a1ce875fe1e50f7f2413292f43c2))


### Build System

* ignore CVE-2023-51774 until after release ([54488d4](https://github.com/nla/nla-blacklight/commit/54488d469811c2ee3bbc9203a0b723ffebf041e0))
* point nla-blacklight_common to main branch ([91ca9a4](https://github.com/nla/nla-blacklight/commit/91ca9a4d3dba42464173d1f2cea7a9581126b47d))
* update nla-blacklight_common and bundler config ([9a11ce2](https://github.com/nla/nla-blacklight/commit/9a11ce267843d0b3d7067de4587cfe937abe1a80))
* upgrade blacklight ([5048570](https://github.com/nla/nla-blacklight/commit/504857089746272f9c6b69e90c183f421c23c085))


### Continuous Integration

* configure GitHub actions to run RSpec with headless chrome ([014fa6c](https://github.com/nla/nla-blacklight/commit/014fa6c8dbdcbd48347616153d326d9c87712e5b))
* fix release-please config ([5197a07](https://github.com/nla/nla-blacklight/commit/5197a072add51555da190921232eb58b776c43d2))
* fix release-please configuration ([c56f30e](https://github.com/nla/nla-blacklight/commit/c56f30ebc832654a57f7b310a02ae0f4df7e794b))
* fix release-please workflow PR generation ([54b8f93](https://github.com/nla/nla-blacklight/commit/54b8f9376d8c801b366a13f665f6dcc9c3baef33))
* update release-please token ([a8ee5c7](https://github.com/nla/nla-blacklight/commit/a8ee5c766a8fe0686e23c02e4641c1759c2a11f6))
* Update release-please.yml ([1c4048e](https://github.com/nla/nla-blacklight/commit/1c4048ed55457779538d1042e99baf818fe88884))

## [3.3.1](https://github.com/nla/nla-blacklight/compare/nla-blacklight/3.3.0...nla-blacklight/3.3.1) (2024-09-05)


### Miscellaneous

* **deps-dev:** bump faker from 3.4.1 to 3.4.2 ([7ef058a](https://github.com/nla/nla-blacklight/commit/7ef058ac47138e4827d4a21d69f87504adba8900))
* **deps-dev:** bump rspec-rails from 6.1.3 to 6.1.4 ([956c837](https://github.com/nla/nla-blacklight/commit/956c837c5a7976863589743eba61f965a08b0c55))
* **deps-dev:** bump rubocop-rspec from 3.0.3 to 3.0.4 ([0ab9487](https://github.com/nla/nla-blacklight/commit/0ab94872de0f6dc8f824b36380d9729f822bc9c9))
* **deps-dev:** bump selenium-webdriver from 4.22.0 to 4.23.0 ([4ac2747](https://github.com/nla/nla-blacklight/commit/4ac274790b4769a9f730c4703ad7a7eab436d6e4))
* **deps-dev:** bump shoulda-matchers from 6.2.0 to 6.4.0 ([8373d49](https://github.com/nla/nla-blacklight/commit/8373d49ce3afb3f5326e3ba7816b36196004870d))
* **deps:** bump @hotwired/turbo-rails from 8.0.4 to 8.0.5 ([799dcb2](https://github.com/nla/nla-blacklight/commit/799dcb2c9f969a458481fbd169d5dcdebbfa0ce6))
* **deps:** bump autoprefixer from 10.4.19 to 10.4.20 ([178a765](https://github.com/nla/nla-blacklight/commit/178a7659a9d37351bbfb621cd17cce21eec66c40))
* **deps:** bump blacklight-marc from 8.1.3 to 8.1.4 ([8a614a5](https://github.com/nla/nla-blacklight/commit/8a614a5f5ee2da3aaa5682fa91b0ac68ea0b8819))
* **deps:** bump bootsnap from 1.18.3 to 1.18.4 ([c095b84](https://github.com/nla/nla-blacklight/commit/c095b8438cf602de2d8213a168603529d74ecf7f))
* **deps:** bump brakeman from 6.1.2 to 6.2.1 ([ecc0918](https://github.com/nla/nla-blacklight/commit/ecc09186d074c156a62ff3f4a73c1377fa502f34))
* **deps:** bump bundler-audit from 0.9.1 to 0.9.2 ([19d248a](https://github.com/nla/nla-blacklight/commit/19d248a0d32ece86e31e8a7a889a34e519d7c09f))
* **deps:** bump cssbundling-rails from 1.4.0 to 1.4.1 ([8e580d0](https://github.com/nla/nla-blacklight/commit/8e580d0d56e50e01c580523291a0258a11c986c0))
* **deps:** bump esbuild from 0.23.0 to 0.23.1 ([2bb1623](https://github.com/nla/nla-blacklight/commit/2bb1623cbd0ec2d677e7c6157d90ab201a248569))
* **deps:** bump fugit from 1.11.0 to 1.11.1 ([cb33847](https://github.com/nla/nla-blacklight/commit/cb338471debd7ee439b8cff8ec04ed59a28119ff))
* **deps:** bump jsbundling-rails from 1.3.0 to 1.3.1 ([82c148f](https://github.com/nla/nla-blacklight/commit/82c148fe8cc84bf23cbd4a7402186d73d4a910ee))
* **deps:** bump micromatch from 4.0.5 to 4.0.8 ([0302d8a](https://github.com/nla/nla-blacklight/commit/0302d8a9ec7b30dbc56911e7f01f524a891f13bb))
* **deps:** bump nla-blacklight_common from `90d3271` to `9074700` ([1916b91](https://github.com/nla/nla-blacklight/commit/1916b91dfbc4da9129f33429623f00ef22fc0ae4))
* **deps:** bump nla-blacklight_common from `c0c44e3` to `90d3271` ([30d6a3c](https://github.com/nla/nla-blacklight/commit/30d6a3c4ad6030632525b5ae8bae33d735386694))
* **deps:** bump phonelib from 0.8.9 to 0.9.1 ([2ba1745](https://github.com/nla/nla-blacklight/commit/2ba174540e2801db210fd2ee664753a645a16516))
* **deps:** bump postcss from 8.4.38 to 8.4.40 ([2fdfdcd](https://github.com/nla/nla-blacklight/commit/2fdfdcd9d47579e1e7f784e4f18ca5d4b5d1cc4d))
* **deps:** bump postcss from 8.4.40 to 8.4.41 ([0459bb3](https://github.com/nla/nla-blacklight/commit/0459bb337cf9b19a5290b625b6665c912ac71c72))
* **deps:** bump redis from 5.2.0 to 5.3.0 ([2035046](https://github.com/nla/nla-blacklight/commit/2035046c70a206c5751a6291642feb38b61a3b0a))
* **deps:** bump rexml from 3.3.2 to 3.3.3 ([56b625c](https://github.com/nla/nla-blacklight/commit/56b625c900a8b411fd61640c416ed3ce65991158))
* **deps:** bump rexml from 3.3.3 to 3.3.6 ([8677726](https://github.com/nla/nla-blacklight/commit/8677726630ff986c2870fdd8a0e9ca22ce5e5342))
* **deps:** bump sass from 1.77.6 to 1.77.8 ([4e0c6e2](https://github.com/nla/nla-blacklight/commit/4e0c6e22657beb868ef46b8816418dd29c0d82fb))
* **deps:** bump sprockets-rails from 3.5.1 to 3.5.2 ([f862757](https://github.com/nla/nla-blacklight/commit/f8627576cddaf14a4f0383456120989a94703b31))
* **deps:** bump stimulus-rails from 1.3.3 to 1.3.4 ([f920b04](https://github.com/nla/nla-blacklight/commit/f920b0400b04640c364b59b0e65219742f72ddc7))
* **deps:** bump strong_migrations from 1.8.0 to 2.0.0 ([c4fa7d3](https://github.com/nla/nla-blacklight/commit/c4fa7d3a2c71b0ad46bd22073d76bed6be57f306))
* **deps:** bump turbo-rails from 2.0.5 to 2.0.6 ([02f1e41](https://github.com/nla/nla-blacklight/commit/02f1e4133565a86082d71ca45c0cca2b43ab4bcf))


### Continuous Integration

* Update release-please.yml ([1c4048e](https://github.com/nla/nla-blacklight/commit/1c4048ed55457779538d1042e99baf818fe88884))

## [3.3.0](https://github.com/nla/nla-blacklight/compare/nla-blacklight/3.2.1...nla-blacklight/3.3.0) (2024-07-09)


### Bug Fixes

* add missing rubocop dependencies and fix deprecated syntax ([90b4c59](https://github.com/nla/nla-blacklight/commit/90b4c599aaf1db4e2d31f06101b1a20d4a93e6a9))
* turn of caching in test ([2d93d72](https://github.com/nla/nla-blacklight/commit/2d93d729112d258ca1ce580e7739454c6c7d3ff8))


### Miscellaneous

* **deps-dev:** bump binding_of_caller from 1.0.0 to 1.0.1 ([ac7f9e4](https://github.com/nla/nla-blacklight/commit/ac7f9e44530ab9a78a6941b12238b06b3d5f41fc))
* **deps-dev:** bump capybara from 3.39.2 to 3.40.0 ([2a019f2](https://github.com/nla/nla-blacklight/commit/2a019f2913f7e7f8b20d83028d1794a17a7c536a))
* **deps-dev:** bump cuprite from 0.15 to 0.15.1 ([0432cc9](https://github.com/nla/nla-blacklight/commit/0432cc91a4b07f3c08f2e5d9b5e83d1658c3b5ec))
* **deps-dev:** bump dotenv from 3.0.3 to 3.1.2 ([f6c6f86](https://github.com/nla/nla-blacklight/commit/f6c6f86ce0f7733fd662d0c59c6b9540bb2f5b51))
* **deps-dev:** bump rack-mini-profiler from 3.1.1 to 3.3.1 ([1512174](https://github.com/nla/nla-blacklight/commit/1512174e0316840bab7ae1cf2c4e83a4c596a090))
* **deps-dev:** bump rspec-rails from 6.1.0 to 6.1.2 ([cb3de71](https://github.com/nla/nla-blacklight/commit/cb3de71d28b985fd903ac4c5f1027e9ad7058027))
* **deps-dev:** bump rubocop-rails from 2.23.1 to 2.25.0 ([008d556](https://github.com/nla/nla-blacklight/commit/008d55658952b0cf644b3ee071e7caf58e748779))
* **deps-dev:** bump rubocop-rspec from 2.25.0 to 3.0.1 ([c78785b](https://github.com/nla/nla-blacklight/commit/c78785b3a644865aee5a2e067f5bb1a61540fc34))
* **deps-dev:** bump rubocop-rspec from 2.25.0 to 3.0.1 ([71de305](https://github.com/nla/nla-blacklight/commit/71de30537c6737fb6e9b185c1569c8571a628e85))
* **deps-dev:** bump selenium-webdriver from 4.17.0 to 4.21.1 ([93ba44c](https://github.com/nla/nla-blacklight/commit/93ba44c5483d16d366449ea8d0ed44072fb03eaf))
* **deps-dev:** bump selenium-webdriver from 4.21.1 to 4.22.0 ([5dcbdd9](https://github.com/nla/nla-blacklight/commit/5dcbdd99323497f0479e449ff3019bf3858e264f))
* **deps-dev:** bump standard from 1.33.0 to 1.39.0 ([1793c3d](https://github.com/nla/nla-blacklight/commit/1793c3d54b8e8ed10d63fa75b2f49c44dfc2587f))
* **deps:** bump blacklight-frontend from 8.0.1 to 8.3.0 ([713344c](https://github.com/nla/nla-blacklight/commit/713344c3d7f0b052588347d96a60dcdf5219400a))
* **deps:** bump mysql2 from 0.5.5 to 0.5.6 ([df73ca8](https://github.com/nla/nla-blacklight/commit/df73ca87a6af3e877ec7f76238616474922ee4f8))
* **deps:** bump nodemon from 3.1.2 to 3.1.3 ([ea4ef76](https://github.com/nla/nla-blacklight/commit/ea4ef764edf56449d225d06c186cf67e995bf61e))
* **deps:** bump nodemon from 3.1.3 to 3.1.4 ([2e0810a](https://github.com/nla/nla-blacklight/commit/2e0810a4d20af3ed9e3e92a877acd691073721b9))
* **deps:** bump phonelib from 0.8.5 to 0.8.9 ([e2b872d](https://github.com/nla/nla-blacklight/commit/e2b872d3860d849df2bdb817072ffae3661d55dd))
* **deps:** bump redis from 5.0.8 to 5.2.0 ([15d1e59](https://github.com/nla/nla-blacklight/commit/15d1e59cb87d7bfdf6b1dc76ce5275c133202743))
* **deps:** bump sass from 1.77.4 to 1.77.6 ([782fe0c](https://github.com/nla/nla-blacklight/commit/782fe0cd88aa2d60cbff7c3468aadeb5b25d9c1d))
* **deps:** bump strong_migrations from 1.7.0 to 1.8.0 ([79e3f74](https://github.com/nla/nla-blacklight/commit/79e3f740eae0edbbf5a69e475736cd6f12a773f4))
* release 3.3.0 ([a47df34](https://github.com/nla/nla-blacklight/commit/a47df3453c453f149f884c18427419e4d0d53e37))
* resolve merge collission ([d493569](https://github.com/nla/nla-blacklight/commit/d493569e08d517cbb0c8cb5308476e5c0e01d53a))
* update nla-blacklight_common dependency ([a283767](https://github.com/nla/nla-blacklight/commit/a283767e560ae0dee135f2065fc304c3099e75d4))
* update version of nla-blacklight_common ([6841109](https://github.com/nla/nla-blacklight/commit/684110922609fdc67c5b647190cebf59fc55405a))


### Build System

* update nla-blacklight_common and bundler config ([9a11ce2](https://github.com/nla/nla-blacklight/commit/9a11ce267843d0b3d7067de4587cfe937abe1a80))
* upgrade blacklight ([5048570](https://github.com/nla/nla-blacklight/commit/504857089746272f9c6b69e90c183f421c23c085))


### Continuous Integration

* update release-please token ([a8ee5c7](https://github.com/nla/nla-blacklight/commit/a8ee5c766a8fe0686e23c02e4641c1759c2a11f6))

## [3.2.1](https://github.com/nla/nla-blacklight/compare/nla-blacklight-v3.2.0...nla-blacklight/3.2.1) (2024-06-13)


### ⚠ BREAKING CHANGES

* upgrade to Blacklight 8
* **solr:** Single document search no longer uses the Blacklight default of /get.

### Features

* add button to return back to item requested ([0dfeb37](https://github.com/nla/nla-blacklight/commit/0dfeb379b0efd0540b1bf99158dde7dc7d8f1d48))
* add button to return to search from request ([3c0e6f6](https://github.com/nla/nla-blacklight/commit/3c0e6f68766c3a0ea425a8dcf095725d1a96b83f))
* add client-side validation for serial requests ([fe21301](https://github.com/nla/nla-blacklight/commit/fe213013da63b374c631586c967d0fc79601f2c5))
* add client-side validation to manuscripts request form ([7a7ba99](https://github.com/nla/nla-blacklight/commit/7a7ba99a2cd628278c971b2d11e02b666097905a))
* add feature flag to disable requesting related features ([1c5b24e](https://github.com/nla/nla-blacklight/commit/1c5b24ed5319ac0c7a033575216f1fd8166b11a3))
* add link to request summary on success page ([85318d2](https://github.com/nla/nla-blacklight/commit/85318d2ca6cb745751bbc149d4cfb57c1d5c7562))
* add spacing to “New Catalogue search” button ([afd77d7](https://github.com/nla/nla-blacklight/commit/afd77d78283ebeea6d46318726d49638eef523d1))
* add validation of map request fields ([6b0e5db](https://github.com/nla/nla-blacklight/commit/6b0e5db79f4f533c822369f9315462955d9a6d61))
* adds copyright info ([d148d2a](https://github.com/nla/nla-blacklight/commit/d148d2ab56f7c9d6f6fa520e28f8b51651eb5c41))
* allow user to change their email address ([ee4806f](https://github.com/nla/nla-blacklight/commit/ee4806ff762c7e9fc2db3c8e6a68c00cbd0aaa03))
* allow user to change their email address ([ed7f646](https://github.com/nla/nla-blacklight/commit/ed7f64682f05f6d1a7920d5323adb9fc4a603c99))
* allow user to change their email address ([b1b05b7](https://github.com/nla/nla-blacklight/commit/b1b05b7615c61d2303dedf16cb6dc6f9e97fb743))
* change error for invalid phone/mobile phone ([5d29eab](https://github.com/nla/nla-blacklight/commit/5d29eab7a4e50cc01b06763911dc46f25658e9d4))
* change Github workflow and release-please config ([e507476](https://github.com/nla/nla-blacklight/commit/e507476e44005677ff1de929bc82f903036c0fde))
* change patron login to Keycloak via OmniAuth ([f0d6482](https://github.com/nla/nla-blacklight/commit/f0d64824d1ff2256213671b089738eab752b0a54))
* customise blacklight ([a5bdc6d](https://github.com/nla/nla-blacklight/commit/a5bdc6dc512756aaa9b30e02cca96d86c6854979))
* customise Blacklight ([02085da](https://github.com/nla/nla-blacklight/commit/02085da5b97edfc54de5211e5f3df02a2983f1c9))
* disable email 2fa from appearing on profile page ([c22c98e](https://github.com/nla/nla-blacklight/commit/c22c98e53e336bc1a79b0ef63a29640d9f64cf8c))
* disable login during FOLIO updates ([de7358a](https://github.com/nla/nla-blacklight/commit/de7358a17c13020818fb3d8fb3c91194a1f0e492))
* display cancellation reason/comment in notes ([f9f7a1b](https://github.com/nla/nla-blacklight/commit/f9f7a1b29a8ab3478562a9d1de309084e0543bf2))
* display patron details ([37c1e6d](https://github.com/nla/nla-blacklight/commit/37c1e6d98d9f40844cde2c274f4bb4b27c8073ff))
* hide account settings behind feature flag ([2e6fa91](https://github.com/nla/nla-blacklight/commit/2e6fa916327cb921f55fb8610f16eda350ae54f8))
* implement email 2fa alert ([a4790de](https://github.com/nla/nla-blacklight/commit/a4790deef59068c1996e23e099eafadae5008ad0))
* implement enabling/disabling of email 2fa from Account Settings ([8e74216](https://github.com/nla/nla-blacklight/commit/8e7421648e17bced73b1729dacac5708b6fa4f58))
* log eResources user access ([375462d](https://github.com/nla/nla-blacklight/commit/375462d5ff1af03e5d75d3f1674405df6f584831))
* make settings form layout responsive ([906e518](https://github.com/nla/nla-blacklight/commit/906e5185e25ef0404a8e83ec86b21b530c00e92a))
* merge main branch and increase test coverage ([a11b7ed](https://github.com/nla/nla-blacklight/commit/a11b7ed516edb795f2703f2823c6209c7f182e53))
* move request details to a modal window ([7d0b091](https://github.com/nla/nla-blacklight/commit/7d0b091188a0cffbe53d5264e43d71182ed84aa3))
* pass "loan" param to catalogue-services ([9823bbd](https://github.com/nla/nla-blacklight/commit/9823bbd4d4a0e8338a6c6e83a83cbc7923b1854e))
* post eresources stats and refactor eresources config ([7ee8405](https://github.com/nla/nla-blacklight/commit/7ee8405b95359597604cc7e46b5a608f9d274b55))
* pull in changes for login page ([39659fb](https://github.com/nla/nla-blacklight/commit/39659fb41b76eb8beaf65c6aa9c9b06a1342b299))
* refactor user details fields into a component ([827c358](https://github.com/nla/nla-blacklight/commit/827c358a68ced299051d74f8fa7630c2f78e50f0))
* remove recent item/issues held ([50ffe76](https://github.com/nla/nla-blacklight/commit/50ffe761cd22197ba68ddf2beb3d9ce9cf409e3a))
* remove seconds from timestamp and change label to "Date" ([097af3b](https://github.com/nla/nla-blacklight/commit/097af3b9ec4bf432cba8d00a000484b07cce3fce))
* remove unnecessary solr_wrapper rake tasks ([0d99739](https://github.com/nla/nla-blacklight/commit/0d99739d7e22d0cab1dbe234d4c0fe1fa810016f))
* Update Join us link in primary nav ([d63037c](https://github.com/nla/nla-blacklight/commit/d63037c2fe4b2239b3643b52d6bc8d013aa843bb))
* Update login with library card text references ([8515b50](https://github.com/nla/nla-blacklight/commit/8515b50af9cce942dc8a67df088475ed05343719))
* update nla-blacklight_common dependency ([d2223a4](https://github.com/nla/nla-blacklight/commit/d2223a4e678331fb06c3b88b257248018af8e95a))
* update README text ([5e31129](https://github.com/nla/nla-blacklight/commit/5e311290b53fa1091a6783d3a0687af6cbee845a))
* Update request item text ([eb8b605](https://github.com/nla/nla-blacklight/commit/eb8b605a3b0a87b93f589df47a3c63d53d498c22))
* update routes annotation ([ff5a49d](https://github.com/nla/nla-blacklight/commit/ff5a49d2fb8b9b590e96846d86f00e7a5a80c350))
* Update text and image for Join library on homepage ([c7be2a2](https://github.com/nla/nla-blacklight/commit/c7be2a2e13e1a3c257697097e02e420bdacfbdaa))
* Update text message for successful request ([3ab0db6](https://github.com/nla/nla-blacklight/commit/3ab0db679a48cbbd10ad11d4d6e989dc83efc2fb))
* Update twitter icon to X ([e853c79](https://github.com/nla/nla-blacklight/commit/e853c7936c258d3aad22b079806f7040e07eb29f))
* upgrade to Blacklight 8 ([6ce93c1](https://github.com/nla/nla-blacklight/commit/6ce93c156793b589993ff1e50d8aad19cd4069f4))
* validate phone and mobile phone details ([28d3147](https://github.com/nla/nla-blacklight/commit/28d3147a7d7d099d7b83d345f1b391e74a606e88))
* validate phone and mobile phone details ([457c1a8](https://github.com/nla/nla-blacklight/commit/457c1a82beafdc82fce81488cbb3f3d81b4fe147))
* validate post code ([5d26c2f](https://github.com/nla/nla-blacklight/commit/5d26c2f87e9772718ef65bdc60e00efa5fe9a50b))


### Bug Fixes

* add placeholders for validation messages ([0aed38d](https://github.com/nla/nla-blacklight/commit/0aed38d707c51ed73290e4d0a08e2a2a72a68f8b))
* add visually-hidden class to hide text from browsers ([153683e](https://github.com/nla/nla-blacklight/commit/153683ec95242a0722a22d8a4cf4d0e4ea930809))
* align labels on tablet view ([4f519bb](https://github.com/nla/nla-blacklight/commit/4f519bbb5d9b0fde5c6f73a289c532d805215fa8))
* bump dotenv and prevent frozen hash issue ([508740d](https://github.com/nla/nla-blacklight/commit/508740d971927926be14d8d1b98c957b1c115545))
* change catalogue record page title size ([6f96475](https://github.com/nla/nla-blacklight/commit/6f964751248f8cd3ccd47b9488c24f8478d2bbd1))
* change limiters and expanders params for EDS API ([4f8b3f2](https://github.com/nla/nla-blacklight/commit/4f8b3f238847095867f8b4082326267ec0e39e06))
* change link to join us page ([421885b](https://github.com/nla/nla-blacklight/commit/421885b53f75c8650d01d88003a4c797ee271c7a))
* change maxlength of email input field ([06ce316](https://github.com/nla/nla-blacklight/commit/06ce3160ac451d89d30e01892baa4e98748fece9))
* change pub_date_ssim to pub_date_si ([80b5369](https://github.com/nla/nla-blacklight/commit/80b5369af9f2f6325777a025a703cfda5a594c00))
* change request alert wording ([7c0c5eb](https://github.com/nla/nla-blacklight/commit/7c0c5eb0178e500e67c5a72624ba67c447253ab3))
* comment out active_storage from production env config ([ad0db78](https://github.com/nla/nla-blacklight/commit/ad0db7833192b842b988aa7ba744c8b866c69c17))
* configure correct Solr search adapter in blacklight.yml ([e90e0f5](https://github.com/nla/nla-blacklight/commit/e90e0f5b165508a4467b768181ddb674845d58ec))
* display error for dependent fields of serials requests ([24fbe23](https://github.com/nla/nla-blacklight/commit/24fbe23a1d264acd7665faeb52a8ea0c50d1da01))
* display record title instead of eResource title ([c64de08](https://github.com/nla/nla-blacklight/commit/c64de084695c45178bbfe0384f94f1c34a25cfe1))
* don't link thumbnail if there is no online link ([cd84ccc](https://github.com/nla/nla-blacklight/commit/cd84ccc3af90ff353b1e28383e3076ae9f22587f))
* downgrade postcss-cli npm dependency ([acc1f7f](https://github.com/nla/nla-blacklight/commit/acc1f7fa7ba0070de93a78d7550d546512c78837))
* fix COinS export code for Zotero ([c5bdf7d](https://github.com/nla/nla-blacklight/commit/c5bdf7d1ed057421ea0ec613202125850684a64f))
* fix instantiation of default request summary to match service ([e3e0cf6](https://github.com/nla/nla-blacklight/commit/e3e0cf60c8f536f4c229e7ec7bcc3ad95640db81))
* fix logout link ([b7ce8b2](https://github.com/nla/nla-blacklight/commit/b7ce8b2a0aa576d5584d9dd4288179f341247620))
* fix missed renamed method calls ([fd723d1](https://github.com/nla/nla-blacklight/commit/fd723d1e9f69090464bad25cf9942aa01cbfc3b7))
* fix nla-blacklight_common dependency path ([93316c0](https://github.com/nla/nla-blacklight/commit/93316c006e0d94941ee620e169e6f13bc401ea65))
* fix rubocop offenses in Blacklight code ([d6880cd](https://github.com/nla/nla-blacklight/commit/d6880cd06181b5ae5d4b2ab4bf571e8766aa527e))
* fix scrollbar styling on Blacklight modal ([c19eb86](https://github.com/nla/nla-blacklight/commit/c19eb861252a3dd962b1d8229ab196d956565152))
* fix styling of blacklight range limit plugin ([d0c383b](https://github.com/nla/nla-blacklight/commit/d0c383b51a7e08b465d3f5c7a2557eec162e7012))
* hide items/issues held for monographs ([2de2717](https://github.com/nla/nla-blacklight/commit/2de2717ff991da0147e0df30dc09b418784f2ff5))
* ignore Brakeman false positives and handle UnsafeRedirectError ([3c681ae](https://github.com/nla/nla-blacklight/commit/3c681ae9f26a14122decfeb1751d523fe0859077))
* improve modal styles ([bb16481](https://github.com/nla/nla-blacklight/commit/bb16481f4cb93cc81d134ba3fd14f2f122476f35))
* include issn in Trove search query ([adff326](https://github.com/nla/nla-blacklight/commit/adff3264eef0573639b7264350881d0bad0b1b30))
* increase email field length to max length in Keycloak ([2da5651](https://github.com/nla/nla-blacklight/commit/2da5651426bb9ed4721e2124de2c52c39607cc18))
* isolate validation of user settings ([1f44de6](https://github.com/nla/nla-blacklight/commit/1f44de6195c7fb03674d87e737a62bee400346a2))
* login page error for non-existent document ([446b1da](https://github.com/nla/nla-blacklight/commit/446b1da6764d080d6a905c2305e9137454fd007e))
* Make image card tiles on homepage equal height ([4b72497](https://github.com/nla/nla-blacklight/commit/4b72497752e36fa7b669c6a0fae72260cd667e0f))
* mark mandatory field with star and reformat maps metadata ([5f5ccf9](https://github.com/nla/nla-blacklight/commit/5f5ccf9fcdb9e3c97e59e80bf0f1e20d05b797be))
* override onFailure method of Blacklight modal ([9a71666](https://github.com/nla/nla-blacklight/commit/9a716667a3e5717c03d7ffcff6c7af257c7b61b7))
* Print modal dialog over multiple pages ([3c9d381](https://github.com/nla/nla-blacklight/commit/3c9d3810b392ade918df207e3a174bf8defa8b30))
* proxy View Online e-resources urls via EzProxy ([0eb076c](https://github.com/nla/nla-blacklight/commit/0eb076c5b6b6dda7bd2a83c4cfe6a31e7f18cca7))
* pull in change to add /logout route ([4ab5fad](https://github.com/nla/nla-blacklight/commit/4ab5fad5edfd243240f785158b9741cd6fc2e227))
* reapply print styles made in deprecated views ([64a3870](https://github.com/nla/nla-blacklight/commit/64a3870868fad94c4a1c0219a142d064de1ef6be))
* remove colon at the end of link text ([775d9dd](https://github.com/nla/nla-blacklight/commit/775d9dd01d4c5038bda6b4bbd5b22e84162d2f03))
* remove deprecated response from search service ([f4d888c](https://github.com/nla/nla-blacklight/commit/f4d888c1d972e744e3a935c889f12a83f20beca8))
* remove limit from language facet ([d71631e](https://github.com/nla/nla-blacklight/commit/d71631e148c448541dd3702ced4d8f255fc9cfd6))
* remove mini_phone from Gemfile.lock ([58d2c2e](https://github.com/nla/nla-blacklight/commit/58d2c2e8cc9d78d7f3d04341d00070893b82e930))
* replace deprecated Bootstrap styles ([74ae599](https://github.com/nla/nla-blacklight/commit/74ae599875c27e3ad5f6664108d2d599ae84d6bb))
* resolve Rubocop errors ([baa7934](https://github.com/nla/nla-blacklight/commit/baa79340853863f0e8dd5e12cf603aab6f150c7b))
* restyle forms for Bootstrap 5 compatibility ([ef1d267](https://github.com/nla/nla-blacklight/commit/ef1d267b9d7ba98e2e511cf81827b9db605bd4fb))
* return to catalogue record instead of holdings item ([9b41cf8](https://github.com/nla/nla-blacklight/commit/9b41cf8f167f6128ffdca618fbfd024404a2ec04))
* set headers to not cache any pages ([e0fce88](https://github.com/nla/nla-blacklight/commit/e0fce8870001c5268c6f86da900c1d8f65c48e6a))
* set json_solr_path to nil to prevent advanced search error ([bc560d2](https://github.com/nla/nla-blacklight/commit/bc560d239a2241bda013f8a1a802ff398955b7ab))
* set print styles ([7dbc483](https://github.com/nla/nla-blacklight/commit/7dbc4832a79b2103befa4ab6e962f3d19bffaa68))
* setting user details during edit ([8cf8e4a](https://github.com/nla/nla-blacklight/commit/8cf8e4a4baccb9f0bd256bea98b345619c5edec3))
* **solr:** use /select for single document search ([31a45a7](https://github.com/nla/nla-blacklight/commit/31a45a759051503cff47e8abad1212cf68787670))
* staff password is not editable ([9eac8ad](https://github.com/nla/nla-blacklight/commit/9eac8ad86e927270eac9f3ccc997a62ff8890a4b))
* style blacklight range limit modal graph ([0213afd](https://github.com/nla/nla-blacklight/commit/0213afd8db4279757f0f97eca7a9e7addb469ba1))
* uncomment call to catalogue services to make reqeust ([06c6837](https://github.com/nla/nla-blacklight/commit/06c6837d6512376f67aeb6a15fdf63630f2fe43a))
* update spacing CSS classes for bootstrap 5 ([cf7c7ae](https://github.com/nla/nla-blacklight/commit/cf7c7aee96582919c41e90ab18dc8b73f060c964))
* update vulnerable dependencies ([20b9c95](https://github.com/nla/nla-blacklight/commit/20b9c95f198339fca6e4b3211f3b657a9e296eb7))
* update webmocks to remove agent header ([b42c92a](https://github.com/nla/nla-blacklight/commit/b42c92a96e5bfdf3fd3ca3bf8e2b86c18944ba21))


### Reverts

* no need to customise DocumentComponent ([a87be61](https://github.com/nla/nla-blacklight/commit/a87be61ab4d8679c92042d5a35f7862869cab013))
* reverse ip lookup change ([d50085d](https://github.com/nla/nla-blacklight/commit/d50085d8fe1a125bfcf5ea6099b0fc02ac1578d0))
* revert disabling of email 2FA ([3ea8aae](https://github.com/nla/nla-blacklight/commit/3ea8aaeb8ad35b95ae280bdde7a3ec121a979656))
* revert display of year, enumeration and chronology ([2683ce2](https://github.com/nla/nla-blacklight/commit/2683ce20032d9296557df73131dc1647b1e699b5))
* revert removal of solr_wrapper rake task ([fa54c03](https://github.com/nla/nla-blacklight/commit/fa54c039343347f9a8a03eb042b6c28a24ff9a80))
* rollback per page of catalogue results in bento search ([8c67cd8](https://github.com/nla/nla-blacklight/commit/8c67cd87b1e8bf86ae6345e4644c02a3d12eebd8))


### Miscellaneous

* bump nodejs dependencies ([2ef31f1](https://github.com/nla/nla-blacklight/commit/2ef31f138a919e2213e12605972c617b357e1b67))
* clean up JS console logging ([692e8fb](https://github.com/nla/nla-blacklight/commit/692e8fb735f97f45b58519455875f4aaff051c95))
* **deps-dev:** bump cuprite from 0.14.3 to 0.15 ([b2a2e26](https://github.com/nla/nla-blacklight/commit/b2a2e26e0462c0a6d120f4d6eec48567bc5a3b51))
* **deps-dev:** bump debug from 1.8.0 to 1.9.2 ([b898dac](https://github.com/nla/nla-blacklight/commit/b898daca05f458cab21e1adad7bf201fd1324e46))
* **deps-dev:** bump factory_bot_rails from 6.4.2 to 6.4.3 ([11dc586](https://github.com/nla/nla-blacklight/commit/11dc5863b512514f1f044a05fc82f9f44765533a))
* **deps-dev:** bump faker from 3.2.2 to 3.2.3 ([be2d44f](https://github.com/nla/nla-blacklight/commit/be2d44fab97464d7b4452e0134f8fdeb82b0ab5c))
* **deps-dev:** bump mock_redis from 0.37.0 to 0.39.0 ([f37e083](https://github.com/nla/nla-blacklight/commit/f37e0836bad1e598336711ef6a6bfabba4fde3c6))
* **deps-dev:** bump mock_redis from 0.39.0 to 0.44.0 ([4f7f61a](https://github.com/nla/nla-blacklight/commit/4f7f61a0ba78e518fe7f4aac0d054fa755d294a2))
* **deps-dev:** bump rdoc from 6.6.0 to 6.7.0 ([6bbd5c5](https://github.com/nla/nla-blacklight/commit/6bbd5c59c6f9049be3822574e6f948ccc4e2a524))
* **deps-dev:** bump rubocop-performance from 1.19.0 to 1.19.1 ([6f94a14](https://github.com/nla/nla-blacklight/commit/6f94a14ecbd23ba568dfe25a31525958cc88c0da))
* **deps-dev:** bump rubocop-rails from 2.20.2 to 2.21.0 ([8ed49dc](https://github.com/nla/nla-blacklight/commit/8ed49dc02230a91f5577ada4ce4fd00049c620f1))
* **deps-dev:** bump rubocop-rails from 2.21.0 to 2.21.1 ([31db190](https://github.com/nla/nla-blacklight/commit/31db19001728321503bb8a0cd0d8f039ee061696))
* **deps-dev:** bump rubocop-rails from 2.21.1 to 2.21.2 ([9733842](https://github.com/nla/nla-blacklight/commit/9733842d4e75325e3a674168680de13ee98e89be))
* **deps-dev:** bump rubocop-rspec from 2.23.2 to 2.24.0 ([ce85cc0](https://github.com/nla/nla-blacklight/commit/ce85cc0ceb83d1dded98d97dcd58b652bb044655))
* **deps-dev:** bump rubocop-rspec from 2.24.0 to 2.24.1 ([09a7f63](https://github.com/nla/nla-blacklight/commit/09a7f63d7e6cbb606adaaccd53123a0d367081a8))
* **deps-dev:** bump rubocop-rspec from 2.24.1 to 2.25.0 ([e2bed18](https://github.com/nla/nla-blacklight/commit/e2bed185cb958a9a45789305c9204c492c614a30))
* **deps-dev:** bump selenium-webdriver from 4.12.0 to 4.13.1 ([fa09654](https://github.com/nla/nla-blacklight/commit/fa09654bf1bc8897743333625d14c1ddaca81f19))
* **deps-dev:** bump selenium-webdriver from 4.14.0 to 4.15.0 ([c5a762e](https://github.com/nla/nla-blacklight/commit/c5a762efbfdb532505a2279c2d8698e4a915e7fa))
* **deps-dev:** bump selenium-webdriver from 4.15.0 to 4.17.0 ([29f4825](https://github.com/nla/nla-blacklight/commit/29f4825b47f9f41407037092d59b612c5d033dbe))
* **deps-dev:** bump shoulda-matchers from 5.3.0 to 6.2.0 ([f5313b4](https://github.com/nla/nla-blacklight/commit/f5313b46a50f4f9264e11a6ff5db2e9c624c17b9))
* **deps-dev:** bump stackprof from 0.2.25 to 0.2.26 ([bd00f86](https://github.com/nla/nla-blacklight/commit/bd00f868ad0bb290b6c5bf274288b3f748aff502))
* **deps-dev:** bump standard and rubocop-performance ([c492b84](https://github.com/nla/nla-blacklight/commit/c492b84f4b9489205a87f7372d3995aea7b43d12))
* **deps-dev:** bump standard from 1.31.0 to 1.31.1 ([883a365](https://github.com/nla/nla-blacklight/commit/883a365b3b09ce5f2f38503ef53c3bca6ffde596))
* **deps-dev:** bump webmock from 3.19.1 to 3.23.0 ([9b1f44e](https://github.com/nla/nla-blacklight/commit/9b1f44e7439914ba27ac7d05f0aae64337657521))
* **deps:** bump @hotwired/turbo-rails from 7.3.0 to 8.0.4 ([8482ab0](https://github.com/nla/nla-blacklight/commit/8482ab0ead24de503a919b2a32be869d6edb8c0d))
* **deps:** bump actionpack from 7.0.8.3 to 7.0.8.4 ([64a73ce](https://github.com/nla/nla-blacklight/commit/64a73ce8d6c9218be1660ba87ce4f5101d19b415))
* **deps:** bump actions/checkout from 3 to 4 ([65eda91](https://github.com/nla/nla-blacklight/commit/65eda9188fde828ded0e3a346d03558e34c91c3c))
* **deps:** bump autoprefixer from 10.4.17 to 10.4.19 ([b4fe092](https://github.com/nla/nla-blacklight/commit/b4fe0921bb5dc0d310c72b098f1bfee945ad0297))
* **deps:** bump blacklight from 7.34.0 to 7.35.0 ([c6cdf4b](https://github.com/nla/nla-blacklight/commit/c6cdf4b01e657790286e1ceef84497bb5ec6f6e7))
* **deps:** bump blacklight_range_limit from 8.3.0 to 8.4.0 ([d375a25](https://github.com/nla/nla-blacklight/commit/d375a25b60ddb23ae908a0f55487b85084f32c75))
* **deps:** bump bootsnap from 1.16.0 to 1.17.0 ([0fb254e](https://github.com/nla/nla-blacklight/commit/0fb254e9e572c5c1e3c90536a620f1480aa42998))
* **deps:** bump bootsnap from 1.17.0 to 1.18.3 ([326eb41](https://github.com/nla/nla-blacklight/commit/326eb41da0210c043ec1e96ae40828f79049a04e))
* **deps:** bump braces from 3.0.2 to 3.0.3 ([da06086](https://github.com/nla/nla-blacklight/commit/da060869b79f658a2bb2c613724a4f0a949ba4f2))
* **deps:** bump cssbundling-rails from 1.3.3 to 1.4.0 ([3862885](https://github.com/nla/nla-blacklight/commit/3862885d89d68cb7922797ff5ba585fc7143f281))
* **deps:** bump esbuild from 0.19.2 to 0.20.0 ([9247f41](https://github.com/nla/nla-blacklight/commit/9247f41e188d619bc1f35960110097c1212153c2))
* **deps:** bump esbuild from 0.20.0 to 0.21.4 ([553d761](https://github.com/nla/nla-blacklight/commit/553d7616ac461a6e84889616a30a1bc6e28ff64c))
* **deps:** bump esbuild from 0.21.4 to 0.21.5 ([40feac3](https://github.com/nla/nla-blacklight/commit/40feac31beb4f75b7f40ff633d1dd88df5cdc666))
* **deps:** bump google-github-actions/release-please-action ([f9d2215](https://github.com/nla/nla-blacklight/commit/f9d2215939afd22f14c33a06d32595d928d4c2c5))
* **deps:** bump hiredis-client from 0.16.0 to 0.17.0 ([dd53467](https://github.com/nla/nla-blacklight/commit/dd53467b597f4c1e5715321425019047e2947bb4))
* **deps:** bump hiredis-client from 0.17.0 to 0.17.1 ([ab15495](https://github.com/nla/nla-blacklight/commit/ab15495578d56a027c276acd28622f3d5f304371))
* **deps:** bump hiredis-client from 0.17.1 to 0.18.0 ([f701a89](https://github.com/nla/nla-blacklight/commit/f701a8917f62afec13ea780d3c013e2b083e4b33))
* **deps:** bump hiredis-client from 0.18.0 to 0.22.2 ([aad37e4](https://github.com/nla/nla-blacklight/commit/aad37e415e45a080e7f09186b9cf89e29b457e6b))
* **deps:** bump importmap-rails from 1.2.1 to 1.2.3 ([ac4f2b1](https://github.com/nla/nla-blacklight/commit/ac4f2b17919bdc69233010a5a45cabfcb96d346f))
* **deps:** bump nodemon from 3.0.1 to 3.0.3 ([8d55613](https://github.com/nla/nla-blacklight/commit/8d55613ee3cee6c61150fb547b627f3110e6b844))
* **deps:** bump nodemon from 3.0.3 to 3.1.0 ([bc69950](https://github.com/nla/nla-blacklight/commit/bc69950f6ca57ee9ceab1cccb3764c56f7ae8308))
* **deps:** bump nodemon from 3.1.0 to 3.1.2 ([863f38e](https://github.com/nla/nla-blacklight/commit/863f38e595d58d75b75f09a7b2b7e36623517a25))
* **deps:** bump nokogiri from 1.16.0 to 1.16.2 ([ef393c4](https://github.com/nla/nla-blacklight/commit/ef393c47f1b8d6b6c7c07879ffe74d2d4f600eb6))
* **deps:** bump postcss from 8.4.29 to 8.4.31 ([6ccbfe2](https://github.com/nla/nla-blacklight/commit/6ccbfe25fbf3cc9d9656753a63b07b638bae09e6))
* **deps:** bump postcss from 8.4.29 to 8.4.33 ([301fac0](https://github.com/nla/nla-blacklight/commit/301fac0113a2c76d64da28e92fdeeeee4649e162))
* **deps:** bump postcss from 8.4.33 to 8.4.38 ([fb58776](https://github.com/nla/nla-blacklight/commit/fb58776cb0063ee2aa9568453cc2186b82a31a81))
* **deps:** bump postcss-cli from 10.1.0 to 11.0.0 ([55100be](https://github.com/nla/nla-blacklight/commit/55100be96413a941501bb7e6c3d9885e0aca547a))
* **deps:** bump puma from 6.3.1 to 6.4.0 ([23d7c02](https://github.com/nla/nla-blacklight/commit/23d7c0297d8abf4ad712ec4e20317620db2a24dc))
* **deps:** bump rails from 7.0.7.2 to 7.0.8 ([7405ddc](https://github.com/nla/nla-blacklight/commit/7405ddc0b84020368705f294e721dc927fcb2f2e))
* **deps:** bump redis from 5.0.7 to 5.0.8 ([01646f4](https://github.com/nla/nla-blacklight/commit/01646f44b94bd21aea6184d5be160327b8f833d7))
* **deps:** bump rexml from 3.2.6 to 3.2.8 ([4ee2f9b](https://github.com/nla/nla-blacklight/commit/4ee2f9b834b33708297b2a405500f8a69d45c08b))
* **deps:** bump sass from 1.71.1 to 1.77.4 ([4455ad0](https://github.com/nla/nla-blacklight/commit/4455ad0cfb6bec4bb133b400deb7878e5a1c86b2))
* **deps:** bump stimulus-rails from 1.3.0 to 1.3.3 ([0720cbf](https://github.com/nla/nla-blacklight/commit/0720cbf914bdf8544e3b81926c5040457a15f789))
* **deps:** bump strong_migrations from 1.6.1 to 1.6.2 ([fdc363a](https://github.com/nla/nla-blacklight/commit/fdc363a46677e5c23e230dcabf20ceedb781e322))
* **deps:** bump strong_migrations from 1.6.2 to 1.6.3 ([0ade61b](https://github.com/nla/nla-blacklight/commit/0ade61b62482be802e89ab75e68f1ac5dd6f822b))
* **deps:** bump strong_migrations from 1.6.3 to 1.6.4 ([09f5c79](https://github.com/nla/nla-blacklight/commit/09f5c7904cfc0497edb07582d9772798246609dc))
* **deps:** bump strong_migrations from 1.6.4 to 1.7.0 ([e086f40](https://github.com/nla/nla-blacklight/commit/e086f401990abbb53238da609231cb2f6f1b4d16))
* **deps:** bump turbo-rails from 1.5.0 to 2.0.5 ([be17caf](https://github.com/nla/nla-blacklight/commit/be17cafc0d7945fc6c65ca9101d3944cd16fa301))
* **deps:** bump yabeda-prometheus from 0.9.0 to 0.9.1 ([940bea1](https://github.com/nla/nla-blacklight/commit/940bea162d8784e22312909b7ca710b0638037a4))
* fix miniprofiler storage in remote dev env ([be8aec7](https://github.com/nla/nla-blacklight/commit/be8aec78c055b94ae9479fd642d07f45e52e0b0b))
* ignore style error ([5d4a45f](https://github.com/nla/nla-blacklight/commit/5d4a45fa6fe3218b83d8e92baecb8a9b7d31c7c5))
* **main:** release 2.10.0 ([1a04498](https://github.com/nla/nla-blacklight/commit/1a04498c717014d0e63a3ce3ebf6ce6118325b90))
* **main:** release 2.11.0 ([1adc001](https://github.com/nla/nla-blacklight/commit/1adc001fab6e2fd7f5b736afb5133fdb009aabf1))
* **main:** release 2.11.1 ([b7245c0](https://github.com/nla/nla-blacklight/commit/b7245c0cbfba91e30f6252463c77e7e62cad9603))
* **main:** release 2.6.0 ([66bbf91](https://github.com/nla/nla-blacklight/commit/66bbf91cf810c342f2c0c86ae2634c455de38c23))
* **main:** release 2.7.0 ([896c2ba](https://github.com/nla/nla-blacklight/commit/896c2ba3666d6134e47fe97ad26a149e450da652))
* **main:** release 2.8.0 ([befd112](https://github.com/nla/nla-blacklight/commit/befd112eb37d738d292bf3c3b1136a71dd6255a5))
* **main:** release 2.9.0 ([7ea458d](https://github.com/nla/nla-blacklight/commit/7ea458dc413d91a4640592f363ca11486907bb6e))
* **main:** release 3.0.0 ([a577ea1](https://github.com/nla/nla-blacklight/commit/a577ea1437611b30b7e6d902ccd5d5b86d85307e))
* **main:** release 3.1.0 ([3aac3a2](https://github.com/nla/nla-blacklight/commit/3aac3a2789c4cc1fd6940342c6042a8d141afc10))
* **main:** release 3.2.0 ([f3ade93](https://github.com/nla/nla-blacklight/commit/f3ade93168185ad34ffbe2fb31b0ac00e5fa3660))
* merge changes from main ([d5f71e6](https://github.com/nla/nla-blacklight/commit/d5f71e63461601fc922be8fd5a3dc9728be40ca3))
* merge from main ([555a7eb](https://github.com/nla/nla-blacklight/commit/555a7ebf105a483e5b8d78829506acaddd1dd612))
* merge from main ([c6bccd1](https://github.com/nla/nla-blacklight/commit/c6bccd155a6cf3746c8c130ffe5b4259ea416950))
* merge from main ([3181a79](https://github.com/nla/nla-blacklight/commit/3181a7947b24a81ebcd36928587b48a5b6930482))
* merge from main and fix tests ([6be3d69](https://github.com/nla/nla-blacklight/commit/6be3d69790f2395f0ad6147d4723a1b5ceefc2e7))
* merge from main branch and fix tests ([3ffc00a](https://github.com/nla/nla-blacklight/commit/3ffc00ad27bc3f14db861ac4028811391c062f19))
* merge main branch ([dc4f5a8](https://github.com/nla/nla-blacklight/commit/dc4f5a8809ca678c388fbd1671984e44d197ecc8))
* merge main branch ([00c2564](https://github.com/nla/nla-blacklight/commit/00c2564a92abeb198cbe36355137bff1f074cea1))
* prepare 3.0.0 release ([58a5c2f](https://github.com/nla/nla-blacklight/commit/58a5c2f230553581d0d871fd85db2317d3d840cf))
* prepare for release ([081e65b](https://github.com/nla/nla-blacklight/commit/081e65b3a04ef82130dc726d11e1641a876c98c4))
* prepare for release ([223f82a](https://github.com/nla/nla-blacklight/commit/223f82a7e465354a1e836cf8afd3c34f65f3d992))
* prepare for release ([9050653](https://github.com/nla/nla-blacklight/commit/9050653ac21a10ab35a9de5fe91c8e78fc697592))
* prepare release ([a2f4ff3](https://github.com/nla/nla-blacklight/commit/a2f4ff3abd7876f0601d2880927eb8ba6cef0c93))
* prepare release ([10827fb](https://github.com/nla/nla-blacklight/commit/10827fb72e4ab10e1b19880f0192899d6ea5542d))
* prepare release ([413c1f2](https://github.com/nla/nla-blacklight/commit/413c1f2b1af1528dff93795fad0dfc1ecda85f31))
* prepare release ([dadce02](https://github.com/nla/nla-blacklight/commit/dadce0278634fa11a683432cdfbe618adc1e0246))
* pull in backchannel logout changes ([08648bb](https://github.com/nla/nla-blacklight/commit/08648bbfec3fa89aa099e4eeebfa51d5bfd0e793))
* pull in changes from nla-blacklight_common ([cd4aec7](https://github.com/nla/nla-blacklight/commit/cd4aec785b105c121000ab0505fd1be22f8ad492))
* pull in changes in common code ([f0f93ea](https://github.com/nla/nla-blacklight/commit/f0f93eaccbf6fc60345c2112464f33aadb4b7ae7))
* pull in changes to login page text ([1a217c4](https://github.com/nla/nla-blacklight/commit/1a217c4a0336fda9e1c6f0786be469e906e749e8))
* pull in fixes to session_token ([e4f2013](https://github.com/nla/nla-blacklight/commit/e4f201360783e74c7f8f916985f344a1d7c229ec))
* pull in patron Keycloak login changes ([c3764f3](https://github.com/nla/nla-blacklight/commit/c3764f3c62674bbc0b58918262806414ef0eae9d))
* release 3.2.0 ([a38cd66](https://github.com/nla/nla-blacklight/commit/a38cd66c5d6a3e45b0121d2fbfe0c772ec973de9))
* release 3.2.1 ([6d80e54](https://github.com/nla/nla-blacklight/commit/6d80e54f2eb240ec5a0a916cdedb172c1439ed68))
* remove keycloak patron flag ([37c6d99](https://github.com/nla/nla-blacklight/commit/37c6d99e6ed873baec5dfc0209a7128bf685df7b))
* resolve merge conflicts ([0410baf](https://github.com/nla/nla-blacklight/commit/0410baf28bf64830973b9b5392e32712a0934395))
* resolve merge conflicts ([e3e1416](https://github.com/nla/nla-blacklight/commit/e3e1416a5623cf228a19c271143cda73fc00ce64))
* reword comments ([136f3b2](https://github.com/nla/nla-blacklight/commit/136f3b20a813f60e90f198bd0f0644e92cadfbd3))
* update bundler version ([ae6f6ad](https://github.com/nla/nla-blacklight/commit/ae6f6ad670af949ea2976c05fea7553e23ac92b0))
* update dependencies ([b0abeab](https://github.com/nla/nla-blacklight/commit/b0abeab2547df25456d4c224ec43f5e9fa0e4385))
* update from main ([f935e7d](https://github.com/nla/nla-blacklight/commit/f935e7d05786f79c8eaa794704806d8255a02815))
* update from main branch ([cecca62](https://github.com/nla/nla-blacklight/commit/cecca62392279dea68d7179e46adb432693ff856))
* update nla-blacklight_common ([fbc6c20](https://github.com/nla/nla-blacklight/commit/fbc6c209f399c018cff76f7d4c1eba4f907c074f))
* update nla-blacklight_common dependency ([22d3f32](https://github.com/nla/nla-blacklight/commit/22d3f326ff40ee3f815ef26c3c2f10f576e6759c))
* update nla-blacklight_common dependency ([b4883bf](https://github.com/nla/nla-blacklight/commit/b4883bf656a7893b45843052b1f631f529a178bd))
* update nla-blacklight_common dependency ([163cfe9](https://github.com/nla/nla-blacklight/commit/163cfe9eedc6d7e9dcea874d137d64d7ec2fb23c))
* update nla-blacklight_common dependency ([fe223f6](https://github.com/nla/nla-blacklight/commit/fe223f65b4f42c97fdd3e33a878b5ecc5c5f6f38))
* update nla-blacklight_common dependency and config examples ([ab62de2](https://github.com/nla/nla-blacklight/commit/ab62de2d915975bd8c1ad863c105f8a57d4a8722))
* update solr config ([e583c6f](https://github.com/nla/nla-blacklight/commit/e583c6f9a2d01350a5db06174a0f93dbb855b559))
* upgrade dependencies ([1ea8f9f](https://github.com/nla/nla-blacklight/commit/1ea8f9f87d71164b2fae5642ea7ba7ffefc81398))
* upgrade dependencies ([0b0c9e3](https://github.com/nla/nla-blacklight/commit/0b0c9e331323edfe481b208828c6f3c3d00ca4b2))
* upgrade nl-blacklight_common dependency ([9c92016](https://github.com/nla/nla-blacklight/commit/9c920169b5ad772b6a032a59518bc346f2834361))
* upgrade nla-blacklight_common dependency ([ecf0967](https://github.com/nla/nla-blacklight/commit/ecf09670eb7aab06ee1b06d64c322e0457b6236c))
* upgrade setup script and env ribbon ([949bb51](https://github.com/nla/nla-blacklight/commit/949bb51731431193b42e0277f8463f758bed2035))


### Code Refactoring

* get collection names from Solr response instead of MARC ([9f05cf9](https://github.com/nla/nla-blacklight/commit/9f05cf9adbbcea707d0248e4b93d704e9e514ff7))
* link directly to Copies Direct instead of submitting form ([794c505](https://github.com/nla/nla-blacklight/commit/794c505edf4e3b7c609b368995631a01215d0fea))
* move global message render to a common location ([6fbe591](https://github.com/nla/nla-blacklight/commit/6fbe59194906fe2b002c257e6f2a7496deaddf45))
* pull in changes to staff login button style ([cd2f659](https://github.com/nla/nla-blacklight/commit/cd2f659165be060337303bab4b3e6da71bfe0151))
* re-order user details order and render only with value ([6635692](https://github.com/nla/nla-blacklight/commit/6635692bdcb150031f6a7ce57be3ac8be02367a7))
* remove custom CitationComponent ([99cdfc8](https://github.com/nla/nla-blacklight/commit/99cdfc80b2ce076c457efa550827267802bbd7b4))
* rename account "settings" to 'profile" ([b0e83a6](https://github.com/nla/nla-blacklight/commit/b0e83a6074521311f70e4344788529b89c3f54ce))
* rename profile strong params methods ([e9b0e81](https://github.com/nla/nla-blacklight/commit/e9b0e81fc077285bf1107a494c332b25558046c5))


### Tests

* add tests for request details ([da40800](https://github.com/nla/nla-blacklight/commit/da408000807625f95cf3e611d8221c5cb624eb4a))
* add tests for user details view ([ec9ca9d](https://github.com/nla/nla-blacklight/commit/ec9ca9d8d2a40625687bf3abef10f358af265727))
* add wait around flaky Capybara test ([f75b4e2](https://github.com/nla/nla-blacklight/commit/f75b4e28d099a558435301c4283f2350830cd14b))
* fix RelatedRecordsComponent tests ([70553e9](https://github.com/nla/nla-blacklight/commit/70553e98b28afbd1a369b3bbf76448adc9aa886f))
* fix search service mock to return correct response format ([9148cca](https://github.com/nla/nla-blacklight/commit/9148ccafca171b73b914ee7035ed53744b19dde4))
* fix SolrDocument tests ([5e74607](https://github.com/nla/nla-blacklight/commit/5e7460767827cef9eeae6d8208a2d505a7b16097))
* fix tests ([f385ca8](https://github.com/nla/nla-blacklight/commit/f385ca8f30710639e1b3c3c438fa2b2373dd53c4))
* fix tests ([a692cef](https://github.com/nla/nla-blacklight/commit/a692cef3214a970e5100e2492a71cdc8e2c7fc25))
* fix tests ([7205de3](https://github.com/nla/nla-blacklight/commit/7205de31a708e39637d9aab61702d23831d2e859))
* fix tests ([e5e23ac](https://github.com/nla/nla-blacklight/commit/e5e23ace331a43c8627902d64cc2442ff60666ae))
* refactor request summary system spec ([a7174d4](https://github.com/nla/nla-blacklight/commit/a7174d4d9fc397d108eee2f338e355b00a06cbdd))
* update method names in solr_document_spec ([f7a0f28](https://github.com/nla/nla-blacklight/commit/f7a0f287ed900f003d41e6a2649a01675a42698d))
* update mobile/phone tests ([90483ca](https://github.com/nla/nla-blacklight/commit/90483cae93a3a1ce875fe1e50f7f2413292f43c2))
* update tests ([1ba2335](https://github.com/nla/nla-blacklight/commit/1ba2335e27947cfd6a7fec05bb02ace0dd36e36b))


### Build System

* ignore CVE-2023-51774 until after release ([54488d4](https://github.com/nla/nla-blacklight/commit/54488d469811c2ee3bbc9203a0b723ffebf041e0))
* point nla-blacklight_common to main branch ([91ca9a4](https://github.com/nla/nla-blacklight/commit/91ca9a4d3dba42464173d1f2cea7a9581126b47d))
* update nla-blacklight_common dependency ([8100dfd](https://github.com/nla/nla-blacklight/commit/8100dfd4c0346169be314a239874a9f054efc075))


### Continuous Integration

* add verify workflow for upgrade ([f1e6e0a](https://github.com/nla/nla-blacklight/commit/f1e6e0a2b4e0ca171a24c60f9b3156d6f1b207ce))
* cache bundled gems in GitHub verify workflow ([18f415f](https://github.com/nla/nla-blacklight/commit/18f415f2b0bde0d669ce9f62478f4c6d97c32c97))
* configure GitHub actions to run RSpec with headless chrome ([014fa6c](https://github.com/nla/nla-blacklight/commit/014fa6c8dbdcbd48347616153d326d9c87712e5b))
* fix release-please config ([5197a07](https://github.com/nla/nla-blacklight/commit/5197a072add51555da190921232eb58b776c43d2))
* fix release-please configuration ([c56f30e](https://github.com/nla/nla-blacklight/commit/c56f30ebc832654a57f7b310a02ae0f4df7e794b))
* fix release-please workflow PR generation ([54b8f93](https://github.com/nla/nla-blacklight/commit/54b8f9376d8c801b366a13f665f6dcc9c3baef33))
* rename hotfix workflow ([8c28bd7](https://github.com/nla/nla-blacklight/commit/8c28bd704ff933d7633769f8318228a5a0e13fd2))

## [3.2.0](https://github.com/nla/nla-blacklight/compare/3.1.0...3.2.0) (2024-06-04)


### Bug Fixes

* setting user details during edit ([8cf8e4a](https://github.com/nla/nla-blacklight/commit/8cf8e4a4baccb9f0bd256bea98b345619c5edec3))


### Reverts

* revert disabling of email 2FA ([3ea8aae](https://github.com/nla/nla-blacklight/commit/3ea8aaeb8ad35b95ae280bdde7a3ec121a979656))


### Miscellaneous

* **deps-dev:** bump debug from 1.8.0 to 1.9.2 ([b898dac](https://github.com/nla/nla-blacklight/commit/b898daca05f458cab21e1adad7bf201fd1324e46))
* **deps-dev:** bump rdoc from 6.6.0 to 6.7.0 ([6bbd5c5](https://github.com/nla/nla-blacklight/commit/6bbd5c59c6f9049be3822574e6f948ccc4e2a524))
* **deps-dev:** bump shoulda-matchers from 5.3.0 to 6.2.0 ([f5313b4](https://github.com/nla/nla-blacklight/commit/f5313b46a50f4f9264e11a6ff5db2e9c624c17b9))
* **deps-dev:** bump webmock from 3.19.1 to 3.23.0 ([9b1f44e](https://github.com/nla/nla-blacklight/commit/9b1f44e7439914ba27ac7d05f0aae64337657521))
* **deps:** bump @hotwired/turbo-rails from 7.3.0 to 8.0.4 ([8482ab0](https://github.com/nla/nla-blacklight/commit/8482ab0ead24de503a919b2a32be869d6edb8c0d))
* **deps:** bump autoprefixer from 10.4.17 to 10.4.19 ([b4fe092](https://github.com/nla/nla-blacklight/commit/b4fe0921bb5dc0d310c72b098f1bfee945ad0297))
* **deps:** bump esbuild from 0.20.0 to 0.21.4 ([553d761](https://github.com/nla/nla-blacklight/commit/553d7616ac461a6e84889616a30a1bc6e28ff64c))
* **deps:** bump hiredis-client from 0.18.0 to 0.22.2 ([aad37e4](https://github.com/nla/nla-blacklight/commit/aad37e415e45a080e7f09186b9cf89e29b457e6b))
* **deps:** bump nodemon from 3.0.3 to 3.1.0 ([bc69950](https://github.com/nla/nla-blacklight/commit/bc69950f6ca57ee9ceab1cccb3764c56f7ae8308))
* **deps:** bump nodemon from 3.1.0 to 3.1.2 ([863f38e](https://github.com/nla/nla-blacklight/commit/863f38e595d58d75b75f09a7b2b7e36623517a25))
* **deps:** bump postcss from 8.4.33 to 8.4.38 ([fb58776](https://github.com/nla/nla-blacklight/commit/fb58776cb0063ee2aa9568453cc2186b82a31a81))
* **deps:** bump rexml from 3.2.6 to 3.2.8 ([4ee2f9b](https://github.com/nla/nla-blacklight/commit/4ee2f9b834b33708297b2a405500f8a69d45c08b))
* **deps:** bump sass from 1.71.1 to 1.77.4 ([4455ad0](https://github.com/nla/nla-blacklight/commit/4455ad0cfb6bec4bb133b400deb7878e5a1c86b2))
* **deps:** bump stimulus-rails from 1.3.0 to 1.3.3 ([0720cbf](https://github.com/nla/nla-blacklight/commit/0720cbf914bdf8544e3b81926c5040457a15f789))
* **deps:** bump turbo-rails from 1.5.0 to 2.0.5 ([be17caf](https://github.com/nla/nla-blacklight/commit/be17cafc0d7945fc6c65ca9101d3944cd16fa301))
* prepare release ([a2f4ff3](https://github.com/nla/nla-blacklight/commit/a2f4ff3abd7876f0601d2880927eb8ba6cef0c93))
* release 3.2.0 ([a38cd66](https://github.com/nla/nla-blacklight/commit/a38cd66c5d6a3e45b0121d2fbfe0c772ec973de9))
* update nla-blacklight_common dependency ([22d3f32](https://github.com/nla/nla-blacklight/commit/22d3f326ff40ee3f815ef26c3c2f10f576e6759c))
* update nla-blacklight_common dependency ([b4883bf](https://github.com/nla/nla-blacklight/commit/b4883bf656a7893b45843052b1f631f529a178bd))

## [3.1.0](https://github.com/nla/nla-blacklight/compare/3.0.0...3.1.0) (2024-05-14)


### Features

* add feature flag to disable requesting related features ([1c5b24e](https://github.com/nla/nla-blacklight/commit/1c5b24ed5319ac0c7a033575216f1fd8166b11a3))
* add spacing to “New Catalogue search” button ([afd77d7](https://github.com/nla/nla-blacklight/commit/afd77d78283ebeea6d46318726d49638eef523d1))
* disable email 2fa from appearing on profile page ([c22c98e](https://github.com/nla/nla-blacklight/commit/c22c98e53e336bc1a79b0ef63a29640d9f64cf8c))
* disable login during FOLIO updates ([de7358a](https://github.com/nla/nla-blacklight/commit/de7358a17c13020818fb3d8fb3c91194a1f0e492))
* implement email 2fa alert ([a4790de](https://github.com/nla/nla-blacklight/commit/a4790deef59068c1996e23e099eafadae5008ad0))
* implement enabling/disabling of email 2fa from Account Settings ([8e74216](https://github.com/nla/nla-blacklight/commit/8e7421648e17bced73b1729dacac5708b6fa4f58))
* update nla-blacklight_common dependency ([d2223a4](https://github.com/nla/nla-blacklight/commit/d2223a4e678331fb06c3b88b257248018af8e95a))
* update routes annotation ([ff5a49d](https://github.com/nla/nla-blacklight/commit/ff5a49d2fb8b9b590e96846d86f00e7a5a80c350))


### Bug Fixes

* downgrade postcss-cli npm dependency ([acc1f7f](https://github.com/nla/nla-blacklight/commit/acc1f7fa7ba0070de93a78d7550d546512c78837))
* include issn in Trove search query ([adff326](https://github.com/nla/nla-blacklight/commit/adff3264eef0573639b7264350881d0bad0b1b30))


### Miscellaneous

* update bundler version ([ae6f6ad](https://github.com/nla/nla-blacklight/commit/ae6f6ad670af949ea2976c05fea7553e23ac92b0))
* update nla-blacklight_common dependency ([163cfe9](https://github.com/nla/nla-blacklight/commit/163cfe9eedc6d7e9dcea874d137d64d7ec2fb23c))
* update nla-blacklight_common dependency and config examples ([ab62de2](https://github.com/nla/nla-blacklight/commit/ab62de2d915975bd8c1ad863c105f8a57d4a8722))

## [3.0.0](https://github.com/nla/nla-blacklight/compare/2.11.1...3.0.0) (2024-03-13)


### ⚠ BREAKING CHANGES

* upgrade to Blacklight 8
* **solr:** Single document search no longer uses the Blacklight default of /get.

### Features

* remove unnecessary solr_wrapper rake tasks ([0d99739](https://github.com/nla/nla-blacklight/commit/0d99739d7e22d0cab1dbe234d4c0fe1fa810016f))
* update README text ([5e31129](https://github.com/nla/nla-blacklight/commit/5e311290b53fa1091a6783d3a0687af6cbee845a))
* upgrade to Blacklight 8 ([6ce93c1](https://github.com/nla/nla-blacklight/commit/6ce93c156793b589993ff1e50d8aad19cd4069f4))


### Bug Fixes

* bump dotenv and prevent frozen hash issue ([508740d](https://github.com/nla/nla-blacklight/commit/508740d971927926be14d8d1b98c957b1c115545))
* change pub_date_ssim to pub_date_si ([80b5369](https://github.com/nla/nla-blacklight/commit/80b5369af9f2f6325777a025a703cfda5a594c00))
* comment out active_storage from production env config ([ad0db78](https://github.com/nla/nla-blacklight/commit/ad0db7833192b842b988aa7ba744c8b866c69c17))
* configure correct Solr search adapter in blacklight.yml ([e90e0f5](https://github.com/nla/nla-blacklight/commit/e90e0f5b165508a4467b768181ddb674845d58ec))
* fix nla-blacklight_common dependency path ([93316c0](https://github.com/nla/nla-blacklight/commit/93316c006e0d94941ee620e169e6f13bc401ea65))
* fix styling of blacklight range limit plugin ([d0c383b](https://github.com/nla/nla-blacklight/commit/d0c383b51a7e08b465d3f5c7a2557eec162e7012))
* ignore Brakeman false positives and handle UnsafeRedirectError ([3c681ae](https://github.com/nla/nla-blacklight/commit/3c681ae9f26a14122decfeb1751d523fe0859077))
* improve modal styles ([bb16481](https://github.com/nla/nla-blacklight/commit/bb16481f4cb93cc81d134ba3fd14f2f122476f35))
* login page error for non-existent document ([446b1da](https://github.com/nla/nla-blacklight/commit/446b1da6764d080d6a905c2305e9137454fd007e))
* Make image card tiles on homepage equal height ([4b72497](https://github.com/nla/nla-blacklight/commit/4b72497752e36fa7b669c6a0fae72260cd667e0f))
* Print modal dialog over multiple pages ([3c9d381](https://github.com/nla/nla-blacklight/commit/3c9d3810b392ade918df207e3a174bf8defa8b30))
* replace deprecated Bootstrap styles ([74ae599](https://github.com/nla/nla-blacklight/commit/74ae599875c27e3ad5f6664108d2d599ae84d6bb))
* resolve Rubocop errors ([baa7934](https://github.com/nla/nla-blacklight/commit/baa79340853863f0e8dd5e12cf603aab6f150c7b))
* **solr:** use /select for single document search ([31a45a7](https://github.com/nla/nla-blacklight/commit/31a45a759051503cff47e8abad1212cf68787670))
* style blacklight range limit modal graph ([0213afd](https://github.com/nla/nla-blacklight/commit/0213afd8db4279757f0f97eca7a9e7addb469ba1))
* uncomment call to catalogue services to make reqeust ([06c6837](https://github.com/nla/nla-blacklight/commit/06c6837d6512376f67aeb6a15fdf63630f2fe43a))
* update spacing CSS classes for bootstrap 5 ([cf7c7ae](https://github.com/nla/nla-blacklight/commit/cf7c7aee96582919c41e90ab18dc8b73f060c964))
* update vulnerable dependencies ([20b9c95](https://github.com/nla/nla-blacklight/commit/20b9c95f198339fca6e4b3211f3b657a9e296eb7))


### Reverts

* no need to customise DocumentComponent ([a87be61](https://github.com/nla/nla-blacklight/commit/a87be61ab4d8679c92042d5a35f7862869cab013))
* reverse ip lookup change ([d50085d](https://github.com/nla/nla-blacklight/commit/d50085d8fe1a125bfcf5ea6099b0fc02ac1578d0))
* revert removal of solr_wrapper rake task ([fa54c03](https://github.com/nla/nla-blacklight/commit/fa54c039343347f9a8a03eb042b6c28a24ff9a80))


### Miscellaneous

* bump nodejs dependencies ([2ef31f1](https://github.com/nla/nla-blacklight/commit/2ef31f138a919e2213e12605972c617b357e1b67))
* clean up JS console logging ([692e8fb](https://github.com/nla/nla-blacklight/commit/692e8fb735f97f45b58519455875f4aaff051c95))
* **deps-dev:** bump factory_bot_rails from 6.4.2 to 6.4.3 ([11dc586](https://github.com/nla/nla-blacklight/commit/11dc5863b512514f1f044a05fc82f9f44765533a))
* **deps-dev:** bump faker from 3.2.2 to 3.2.3 ([be2d44f](https://github.com/nla/nla-blacklight/commit/be2d44fab97464d7b4452e0134f8fdeb82b0ab5c))
* **deps-dev:** bump mock_redis from 0.39.0 to 0.44.0 ([4f7f61a](https://github.com/nla/nla-blacklight/commit/4f7f61a0ba78e518fe7f4aac0d054fa755d294a2))
* **deps-dev:** bump selenium-webdriver from 4.15.0 to 4.17.0 ([29f4825](https://github.com/nla/nla-blacklight/commit/29f4825b47f9f41407037092d59b612c5d033dbe))
* **deps-dev:** bump stackprof from 0.2.25 to 0.2.26 ([bd00f86](https://github.com/nla/nla-blacklight/commit/bd00f868ad0bb290b6c5bf274288b3f748aff502))
* **deps-dev:** bump standard and rubocop-performance ([c492b84](https://github.com/nla/nla-blacklight/commit/c492b84f4b9489205a87f7372d3995aea7b43d12))
* **deps:** bump bootsnap from 1.17.0 to 1.18.3 ([326eb41](https://github.com/nla/nla-blacklight/commit/326eb41da0210c043ec1e96ae40828f79049a04e))
* **deps:** bump cssbundling-rails from 1.3.3 to 1.4.0 ([3862885](https://github.com/nla/nla-blacklight/commit/3862885d89d68cb7922797ff5ba585fc7143f281))
* **deps:** bump esbuild from 0.19.2 to 0.20.0 ([9247f41](https://github.com/nla/nla-blacklight/commit/9247f41e188d619bc1f35960110097c1212153c2))
* **deps:** bump nodemon from 3.0.1 to 3.0.3 ([8d55613](https://github.com/nla/nla-blacklight/commit/8d55613ee3cee6c61150fb547b627f3110e6b844))
* **deps:** bump nokogiri from 1.16.0 to 1.16.2 ([ef393c4](https://github.com/nla/nla-blacklight/commit/ef393c47f1b8d6b6c7c07879ffe74d2d4f600eb6))
* **deps:** bump postcss from 8.4.29 to 8.4.31 ([6ccbfe2](https://github.com/nla/nla-blacklight/commit/6ccbfe25fbf3cc9d9656753a63b07b638bae09e6))
* **deps:** bump postcss from 8.4.29 to 8.4.33 ([301fac0](https://github.com/nla/nla-blacklight/commit/301fac0113a2c76d64da28e92fdeeeee4649e162))
* **deps:** bump postcss-cli from 10.1.0 to 11.0.0 ([55100be](https://github.com/nla/nla-blacklight/commit/55100be96413a941501bb7e6c3d9885e0aca547a))
* **deps:** bump strong_migrations from 1.6.4 to 1.7.0 ([e086f40](https://github.com/nla/nla-blacklight/commit/e086f401990abbb53238da609231cb2f6f1b4d16))
* **deps:** bump yabeda-prometheus from 0.9.0 to 0.9.1 ([940bea1](https://github.com/nla/nla-blacklight/commit/940bea162d8784e22312909b7ca710b0638037a4))
* prepare 3.0.0 release ([58a5c2f](https://github.com/nla/nla-blacklight/commit/58a5c2f230553581d0d871fd85db2317d3d840cf))
* resolve merge conflicts ([0410baf](https://github.com/nla/nla-blacklight/commit/0410baf28bf64830973b9b5392e32712a0934395))
* resolve merge conflicts ([e3e1416](https://github.com/nla/nla-blacklight/commit/e3e1416a5623cf228a19c271143cda73fc00ce64))
* update nla-blacklight_common ([fbc6c20](https://github.com/nla/nla-blacklight/commit/fbc6c209f399c018cff76f7d4c1eba4f907c074f))
* update nla-blacklight_common dependency ([fe223f6](https://github.com/nla/nla-blacklight/commit/fe223f65b4f42c97fdd3e33a878b5ecc5c5f6f38))


### Code Refactoring

* get collection names from Solr response instead of MARC ([9f05cf9](https://github.com/nla/nla-blacklight/commit/9f05cf9adbbcea707d0248e4b93d704e9e514ff7))
* link directly to Copies Direct instead of submitting form ([794c505](https://github.com/nla/nla-blacklight/commit/794c505edf4e3b7c609b368995631a01215d0fea))


### Build System

* ignore CVE-2023-51774 until after release ([54488d4](https://github.com/nla/nla-blacklight/commit/54488d469811c2ee3bbc9203a0b723ffebf041e0))
* point nla-blacklight_common to main branch ([91ca9a4](https://github.com/nla/nla-blacklight/commit/91ca9a4d3dba42464173d1f2cea7a9581126b47d))

## [2.11.1](https://github.com/nla/nla-blacklight/compare/2.11.0...2.11.1) (2023-11-29)


### Bug Fixes

* display record title instead of eResource title ([c64de08](https://github.com/nla/nla-blacklight/commit/c64de084695c45178bbfe0384f94f1c34a25cfe1))
* pull in change to add /logout route ([4ab5fad](https://github.com/nla/nla-blacklight/commit/4ab5fad5edfd243240f785158b9741cd6fc2e227))
* set print styles ([7dbc483](https://github.com/nla/nla-blacklight/commit/7dbc4832a79b2103befa4ab6e962f3d19bffaa68))


### Miscellaneous

* **deps-dev:** bump cuprite from 0.14.3 to 0.15 ([b2a2e26](https://github.com/nla/nla-blacklight/commit/b2a2e26e0462c0a6d120f4d6eec48567bc5a3b51))
* **deps-dev:** bump selenium-webdriver from 4.14.0 to 4.15.0 ([c5a762e](https://github.com/nla/nla-blacklight/commit/c5a762efbfdb532505a2279c2d8698e4a915e7fa))
* **deps:** bump blacklight from 7.34.0 to 7.35.0 ([c6cdf4b](https://github.com/nla/nla-blacklight/commit/c6cdf4b01e657790286e1ceef84497bb5ec6f6e7))
* **deps:** bump blacklight_range_limit from 8.3.0 to 8.4.0 ([d375a25](https://github.com/nla/nla-blacklight/commit/d375a25b60ddb23ae908a0f55487b85084f32c75))
* **deps:** bump bootsnap from 1.16.0 to 1.17.0 ([0fb254e](https://github.com/nla/nla-blacklight/commit/0fb254e9e572c5c1e3c90536a620f1480aa42998))
* prepare release ([10827fb](https://github.com/nla/nla-blacklight/commit/10827fb72e4ab10e1b19880f0192899d6ea5542d))

## [2.11.0](https://github.com/nla/nla-blacklight/compare/2.10.0...2.11.0) (2023-11-17)


### Features

* Update Join us link in primary nav ([d63037c](https://github.com/nla/nla-blacklight/commit/d63037c2fe4b2239b3643b52d6bc8d013aa843bb))
* Update login with library card text references ([8515b50](https://github.com/nla/nla-blacklight/commit/8515b50af9cce942dc8a67df088475ed05343719))
* Update request item text ([eb8b605](https://github.com/nla/nla-blacklight/commit/eb8b605a3b0a87b93f589df47a3c63d53d498c22))
* Update text and image for Join library on homepage ([c7be2a2](https://github.com/nla/nla-blacklight/commit/c7be2a2e13e1a3c257697097e02e420bdacfbdaa))
* Update text message for successful request ([3ab0db6](https://github.com/nla/nla-blacklight/commit/3ab0db679a48cbbd10ad11d4d6e989dc83efc2fb))


### Bug Fixes

* change link to join us page ([421885b](https://github.com/nla/nla-blacklight/commit/421885b53f75c8650d01d88003a4c797ee271c7a))
* change request alert wording ([7c0c5eb](https://github.com/nla/nla-blacklight/commit/7c0c5eb0178e500e67c5a72624ba67c447253ab3))
* fix missed renamed method calls ([fd723d1](https://github.com/nla/nla-blacklight/commit/fd723d1e9f69090464bad25cf9942aa01cbfc3b7))
* increase email field length to max length in Keycloak ([2da5651](https://github.com/nla/nla-blacklight/commit/2da5651426bb9ed4721e2124de2c52c39607cc18))
* set headers to not cache any pages ([e0fce88](https://github.com/nla/nla-blacklight/commit/e0fce8870001c5268c6f86da900c1d8f65c48e6a))
* staff password is not editable ([9eac8ad](https://github.com/nla/nla-blacklight/commit/9eac8ad86e927270eac9f3ccc997a62ff8890a4b))


### Miscellaneous

* **deps-dev:** bump mock_redis from 0.37.0 to 0.39.0 ([f37e083](https://github.com/nla/nla-blacklight/commit/f37e0836bad1e598336711ef6a6bfabba4fde3c6))
* **deps-dev:** bump rubocop-rspec from 2.24.1 to 2.25.0 ([e2bed18](https://github.com/nla/nla-blacklight/commit/e2bed185cb958a9a45789305c9204c492c614a30))
* **deps:** bump hiredis-client from 0.17.1 to 0.18.0 ([f701a89](https://github.com/nla/nla-blacklight/commit/f701a8917f62afec13ea780d3c013e2b083e4b33))
* **deps:** bump importmap-rails from 1.2.1 to 1.2.3 ([ac4f2b1](https://github.com/nla/nla-blacklight/commit/ac4f2b17919bdc69233010a5a45cabfcb96d346f))
* **deps:** bump redis from 5.0.7 to 5.0.8 ([01646f4](https://github.com/nla/nla-blacklight/commit/01646f44b94bd21aea6184d5be160327b8f833d7))
* prepare for release ([081e65b](https://github.com/nla/nla-blacklight/commit/081e65b3a04ef82130dc726d11e1641a876c98c4))
* pull in backchannel logout changes ([08648bb](https://github.com/nla/nla-blacklight/commit/08648bbfec3fa89aa099e4eeebfa51d5bfd0e793))
* pull in changes in common code ([f0f93ea](https://github.com/nla/nla-blacklight/commit/f0f93eaccbf6fc60345c2112464f33aadb4b7ae7))
* pull in fixes to session_token ([e4f2013](https://github.com/nla/nla-blacklight/commit/e4f201360783e74c7f8f916985f344a1d7c229ec))
* remove keycloak patron flag ([37c6d99](https://github.com/nla/nla-blacklight/commit/37c6d99e6ed873baec5dfc0209a7128bf685df7b))


### Code Refactoring

* rename account "settings" to 'profile" ([b0e83a6](https://github.com/nla/nla-blacklight/commit/b0e83a6074521311f70e4344788529b89c3f54ce))
* rename profile strong params methods ([e9b0e81](https://github.com/nla/nla-blacklight/commit/e9b0e81fc077285bf1107a494c332b25558046c5))


### Tests

* fix tests ([f385ca8](https://github.com/nla/nla-blacklight/commit/f385ca8f30710639e1b3c3c438fa2b2373dd53c4))

## [2.10.0](https://github.com/nla/nla-blacklight/compare/2.9.0...2.10.0) (2023-11-03)


### Features

* add client-side validation for serial requests ([fe21301](https://github.com/nla/nla-blacklight/commit/fe213013da63b374c631586c967d0fc79601f2c5))
* add client-side validation to manuscripts request form ([7a7ba99](https://github.com/nla/nla-blacklight/commit/7a7ba99a2cd628278c971b2d11e02b666097905a))
* add validation of map request fields ([6b0e5db](https://github.com/nla/nla-blacklight/commit/6b0e5db79f4f533c822369f9315462955d9a6d61))
* allow user to change their email address ([ee4806f](https://github.com/nla/nla-blacklight/commit/ee4806ff762c7e9fc2db3c8e6a68c00cbd0aaa03))
* allow user to change their email address ([ed7f646](https://github.com/nla/nla-blacklight/commit/ed7f64682f05f6d1a7920d5323adb9fc4a603c99))
* allow user to change their email address ([b1b05b7](https://github.com/nla/nla-blacklight/commit/b1b05b7615c61d2303dedf16cb6dc6f9e97fb743))
* change error for invalid phone/mobile phone ([5d29eab](https://github.com/nla/nla-blacklight/commit/5d29eab7a4e50cc01b06763911dc46f25658e9d4))
* make settings form layout responsive ([906e518](https://github.com/nla/nla-blacklight/commit/906e5185e25ef0404a8e83ec86b21b530c00e92a))
* refactor user details fields into a component ([827c358](https://github.com/nla/nla-blacklight/commit/827c358a68ced299051d74f8fa7630c2f78e50f0))
* remove seconds from timestamp and change label to "Date" ([097af3b](https://github.com/nla/nla-blacklight/commit/097af3b9ec4bf432cba8d00a000484b07cce3fce))
* Update twitter icon to X ([e853c79](https://github.com/nla/nla-blacklight/commit/e853c7936c258d3aad22b079806f7040e07eb29f))
* validate phone and mobile phone details ([28d3147](https://github.com/nla/nla-blacklight/commit/28d3147a7d7d099d7b83d345f1b391e74a606e88))
* validate phone and mobile phone details ([457c1a8](https://github.com/nla/nla-blacklight/commit/457c1a82beafdc82fce81488cbb3f3d81b4fe147))
* validate post code ([5d26c2f](https://github.com/nla/nla-blacklight/commit/5d26c2f87e9772718ef65bdc60e00efa5fe9a50b))


### Bug Fixes

* add placeholders for validation messages ([0aed38d](https://github.com/nla/nla-blacklight/commit/0aed38d707c51ed73290e4d0a08e2a2a72a68f8b))
* align labels on tablet view ([4f519bb](https://github.com/nla/nla-blacklight/commit/4f519bbb5d9b0fde5c6f73a289c532d805215fa8))
* change maxlength of email input field ([06ce316](https://github.com/nla/nla-blacklight/commit/06ce3160ac451d89d30e01892baa4e98748fece9))
* display error for dependent fields of serials requests ([24fbe23](https://github.com/nla/nla-blacklight/commit/24fbe23a1d264acd7665faeb52a8ea0c50d1da01))
* isolate validation of user settings ([1f44de6](https://github.com/nla/nla-blacklight/commit/1f44de6195c7fb03674d87e737a62bee400346a2))
* mark mandatory field with star and reformat maps metadata ([5f5ccf9](https://github.com/nla/nla-blacklight/commit/5f5ccf9fcdb9e3c97e59e80bf0f1e20d05b797be))
* override onFailure method of Blacklight modal ([9a71666](https://github.com/nla/nla-blacklight/commit/9a716667a3e5717c03d7ffcff6c7af257c7b61b7))
* proxy View Online e-resources urls via EzProxy ([0eb076c](https://github.com/nla/nla-blacklight/commit/0eb076c5b6b6dda7bd2a83c4cfe6a31e7f18cca7))
* remove mini_phone from Gemfile.lock ([58d2c2e](https://github.com/nla/nla-blacklight/commit/58d2c2e8cc9d78d7f3d04341d00070893b82e930))
* update webmocks to remove agent header ([b42c92a](https://github.com/nla/nla-blacklight/commit/b42c92a96e5bfdf3fd3ca3bf8e2b86c18944ba21))


### Miscellaneous

* **deps:** bump hiredis-client from 0.17.0 to 0.17.1 ([ab15495](https://github.com/nla/nla-blacklight/commit/ab15495578d56a027c276acd28622f3d5f304371))
* **deps:** bump strong_migrations from 1.6.3 to 1.6.4 ([09f5c79](https://github.com/nla/nla-blacklight/commit/09f5c7904cfc0497edb07582d9772798246609dc))
* prepare for release ([223f82a](https://github.com/nla/nla-blacklight/commit/223f82a7e465354a1e836cf8afd3c34f65f3d992))
* pull in changes to login page text ([1a217c4](https://github.com/nla/nla-blacklight/commit/1a217c4a0336fda9e1c6f0786be469e906e749e8))
* reword comments ([136f3b2](https://github.com/nla/nla-blacklight/commit/136f3b20a813f60e90f198bd0f0644e92cadfbd3))


### Code Refactoring

* pull in changes to staff login button style ([cd2f659](https://github.com/nla/nla-blacklight/commit/cd2f659165be060337303bab4b3e6da71bfe0151))
* re-order user details order and render only with value ([6635692](https://github.com/nla/nla-blacklight/commit/6635692bdcb150031f6a7ce57be3ac8be02367a7))


### Tests

* add tests for user details view ([ec9ca9d](https://github.com/nla/nla-blacklight/commit/ec9ca9d8d2a40625687bf3abef10f358af265727))
* add wait around flaky Capybara test ([f75b4e2](https://github.com/nla/nla-blacklight/commit/f75b4e28d099a558435301c4283f2350830cd14b))
* refactor request summary system spec ([a7174d4](https://github.com/nla/nla-blacklight/commit/a7174d4d9fc397d108eee2f338e355b00a06cbdd))
* update mobile/phone tests ([90483ca](https://github.com/nla/nla-blacklight/commit/90483cae93a3a1ce875fe1e50f7f2413292f43c2))


### Continuous Integration

* configure GitHub actions to run RSpec with headless chrome ([014fa6c](https://github.com/nla/nla-blacklight/commit/014fa6c8dbdcbd48347616153d326d9c87712e5b))

## [2.9.0](https://github.com/nla/nla-blacklight/compare/2.8.0...2.9.0) (2023-10-20)


### Features

* change patron login to Keycloak via OmniAuth ([f0d6482](https://github.com/nla/nla-blacklight/commit/f0d64824d1ff2256213671b089738eab752b0a54))
* display patron details ([37c1e6d](https://github.com/nla/nla-blacklight/commit/37c1e6d98d9f40844cde2c274f4bb4b27c8073ff))
* hide account settings behind feature flag ([2e6fa91](https://github.com/nla/nla-blacklight/commit/2e6fa916327cb921f55fb8610f16eda350ae54f8))
* pull in changes for login page ([39659fb](https://github.com/nla/nla-blacklight/commit/39659fb41b76eb8beaf65c6aa9c9b06a1342b299))


### Bug Fixes

* hide items/issues held for monographs ([2de2717](https://github.com/nla/nla-blacklight/commit/2de2717ff991da0147e0df30dc09b418784f2ff5))
* remove colon at the end of link text ([775d9dd](https://github.com/nla/nla-blacklight/commit/775d9dd01d4c5038bda6b4bbd5b22e84162d2f03))


### Miscellaneous

* prepare for release ([9050653](https://github.com/nla/nla-blacklight/commit/9050653ac21a10ab35a9de5fe91c8e78fc697592))
* pull in patron Keycloak login changes ([c3764f3](https://github.com/nla/nla-blacklight/commit/c3764f3c62674bbc0b58918262806414ef0eae9d))
* update dependencies ([b0abeab](https://github.com/nla/nla-blacklight/commit/b0abeab2547df25456d4c224ec43f5e9fa0e4385))

## [2.8.0](https://github.com/nla/nla-blacklight/compare/2.7.0...2.8.0) (2023-10-04)


### Features

* add link to request summary on success page ([85318d2](https://github.com/nla/nla-blacklight/commit/85318d2ca6cb745751bbc149d4cfb57c1d5c7562))
* display cancellation reason/comment in notes ([f9f7a1b](https://github.com/nla/nla-blacklight/commit/f9f7a1b29a8ab3478562a9d1de309084e0543bf2))
* move request details to a modal window ([7d0b091](https://github.com/nla/nla-blacklight/commit/7d0b091188a0cffbe53d5264e43d71182ed84aa3))
* pass "loan" param to catalogue-services ([9823bbd](https://github.com/nla/nla-blacklight/commit/9823bbd4d4a0e8338a6c6e83a83cbc7923b1854e))
* remove recent item/issues held ([50ffe76](https://github.com/nla/nla-blacklight/commit/50ffe761cd22197ba68ddf2beb3d9ce9cf409e3a))


### Bug Fixes

* fix instantiation of default request summary to match service ([e3e0cf6](https://github.com/nla/nla-blacklight/commit/e3e0cf60c8f536f4c229e7ec7bcc3ad95640db81))


### Miscellaneous

* **deps-dev:** bump rubocop-rails from 2.21.1 to 2.21.2 ([9733842](https://github.com/nla/nla-blacklight/commit/9733842d4e75325e3a674168680de13ee98e89be))
* **deps-dev:** bump rubocop-rspec from 2.24.0 to 2.24.1 ([09a7f63](https://github.com/nla/nla-blacklight/commit/09a7f63d7e6cbb606adaaccd53123a0d367081a8))
* **deps-dev:** bump selenium-webdriver from 4.12.0 to 4.13.1 ([fa09654](https://github.com/nla/nla-blacklight/commit/fa09654bf1bc8897743333625d14c1ddaca81f19))
* **deps:** bump puma from 6.3.1 to 6.4.0 ([23d7c02](https://github.com/nla/nla-blacklight/commit/23d7c0297d8abf4ad712ec4e20317620db2a24dc))
* **deps:** bump strong_migrations from 1.6.2 to 1.6.3 ([0ade61b](https://github.com/nla/nla-blacklight/commit/0ade61b62482be802e89ab75e68f1ac5dd6f822b))


### Tests

* fix tests ([e5e23ac](https://github.com/nla/nla-blacklight/commit/e5e23ace331a43c8627902d64cc2442ff60666ae))


### Continuous Integration

* rename hotfix workflow ([8c28bd7](https://github.com/nla/nla-blacklight/commit/8c28bd704ff933d7633769f8318228a5a0e13fd2))

## [2.7.0](https://github.com/nla/nla-blacklight/compare/2.6.0...2.7.0) (2023-09-22)


### Features

* add button to return back to item requested ([0dfeb37](https://github.com/nla/nla-blacklight/commit/0dfeb379b0efd0540b1bf99158dde7dc7d8f1d48))
* add button to return to search from request ([3c0e6f6](https://github.com/nla/nla-blacklight/commit/3c0e6f68766c3a0ea425a8dcf095725d1a96b83f))
* adds copyright info ([d148d2a](https://github.com/nla/nla-blacklight/commit/d148d2ab56f7c9d6f6fa520e28f8b51651eb5c41))
* log eResources user access ([375462d](https://github.com/nla/nla-blacklight/commit/375462d5ff1af03e5d75d3f1674405df6f584831))


### Bug Fixes

* change limiters and expanders params for EDS API ([4f8b3f2](https://github.com/nla/nla-blacklight/commit/4f8b3f238847095867f8b4082326267ec0e39e06))
* fix rubocop offenses in Blacklight code ([d6880cd](https://github.com/nla/nla-blacklight/commit/d6880cd06181b5ae5d4b2ab4bf571e8766aa527e))
* return to catalogue record instead of holdings item ([9b41cf8](https://github.com/nla/nla-blacklight/commit/9b41cf8f167f6128ffdca618fbfd024404a2ec04))


### Miscellaneous

* **deps-dev:** bump rubocop-performance from 1.19.0 to 1.19.1 ([6f94a14](https://github.com/nla/nla-blacklight/commit/6f94a14ecbd23ba568dfe25a31525958cc88c0da))
* **deps-dev:** bump rubocop-rails from 2.20.2 to 2.21.0 ([8ed49dc](https://github.com/nla/nla-blacklight/commit/8ed49dc02230a91f5577ada4ce4fd00049c620f1))
* **deps-dev:** bump rubocop-rails from 2.21.0 to 2.21.1 ([31db190](https://github.com/nla/nla-blacklight/commit/31db19001728321503bb8a0cd0d8f039ee061696))
* **deps-dev:** bump rubocop-rspec from 2.23.2 to 2.24.0 ([ce85cc0](https://github.com/nla/nla-blacklight/commit/ce85cc0ceb83d1dded98d97dcd58b652bb044655))
* **deps-dev:** bump standard from 1.31.0 to 1.31.1 ([883a365](https://github.com/nla/nla-blacklight/commit/883a365b3b09ce5f2f38503ef53c3bca6ffde596))
* **deps:** bump actions/checkout from 3 to 4 ([65eda91](https://github.com/nla/nla-blacklight/commit/65eda9188fde828ded0e3a346d03558e34c91c3c))
* **deps:** bump hiredis-client from 0.16.0 to 0.17.0 ([dd53467](https://github.com/nla/nla-blacklight/commit/dd53467b597f4c1e5715321425019047e2947bb4))
* **deps:** bump rails from 7.0.7.2 to 7.0.8 ([7405ddc](https://github.com/nla/nla-blacklight/commit/7405ddc0b84020368705f294e721dc927fcb2f2e))
* **deps:** bump strong_migrations from 1.6.1 to 1.6.2 ([fdc363a](https://github.com/nla/nla-blacklight/commit/fdc363a46677e5c23e230dcabf20ceedb781e322))
* ignore style error ([5d4a45f](https://github.com/nla/nla-blacklight/commit/5d4a45fa6fe3218b83d8e92baecb8a9b7d31c7c5))
* prepare release ([413c1f2](https://github.com/nla/nla-blacklight/commit/413c1f2b1af1528dff93795fad0dfc1ecda85f31))
* update solr config ([e583c6f](https://github.com/nla/nla-blacklight/commit/e583c6f9a2d01350a5db06174a0f93dbb855b559))


### Build System

* update nla-blacklight_common dependency ([8100dfd](https://github.com/nla/nla-blacklight/commit/8100dfd4c0346169be314a239874a9f054efc075))


### Continuous Integration

* cache bundled gems in GitHub verify workflow ([18f415f](https://github.com/nla/nla-blacklight/commit/18f415f2b0bde0d669ce9f62478f4c6d97c32c97))

## [2.6.0](https://github.com/nla/nla-blacklight/compare/2.5.0...2.6.0) (2023-09-08)


### Features

* cache eresources config in Redis ([ba9f080](https://github.com/nla/nla-blacklight/commit/ba9f08076cb6ee3d4746823def90d02fbc339dc3))
* post eresources stats and refactor eresources config ([7ee8405](https://github.com/nla/nla-blacklight/commit/7ee8405b95359597604cc7e46b5a608f9d274b55))
* split titles into separate lines ([ae206fa](https://github.com/nla/nla-blacklight/commit/ae206fa3e5ac2bcac9bfe362ed42f64a8beaf99d))


### Bug Fixes

* add text-break class to more links ([43375dc](https://github.com/nla/nla-blacklight/commit/43375dc914de9e2982be2b8f2c02f7206c1c497a))
* add thumbnail width to cache key ([5e89bdc](https://github.com/nla/nla-blacklight/commit/5e89bdc0692b7e009dad291211e5cb8b41e23cdd))
* add yearCaption, enumeration and chronology to request notes ([41e3bcd](https://github.com/nla/nla-blacklight/commit/41e3bcdc1eb2062fca61444a52fbcf4c6b1b1b56))
* break long url text in map search link and url lists ([ef4dab5](https://github.com/nla/nla-blacklight/commit/ef4dab52347c62de1d7ff95b69b97f6f955ee7bb))
* change request prompt ([4968ea7](https://github.com/nla/nla-blacklight/commit/4968ea7ddabaf853934f56be0fafb33577240a1b))
* change requesting prompts ([83d5818](https://github.com/nla/nla-blacklight/commit/83d5818905eea0fd45aa06261629a492cf323100))
* define further gray colours ([09a5053](https://github.com/nla/nla-blacklight/commit/09a5053bfd286c7246c093293c74a1e872035fa8))
* styles for card borders ([58d3d63](https://github.com/nla/nla-blacklight/commit/58d3d63341d3bd3cf1994d3e7a6159060c6fd279))


### Reverts

* revert display of year, enumeration and chronology ([2683ce2](https://github.com/nla/nla-blacklight/commit/2683ce20032d9296557df73131dc1647b1e699b5))


### Miscellaneous

* change session cookie security ([d39c352](https://github.com/nla/nla-blacklight/commit/d39c3521a39fe5aab90d44ed300ee24fea408f4f))
* **deps-dev:** bump mock_redis from 0.36.0 to 0.37.0 ([86c666b](https://github.com/nla/nla-blacklight/commit/86c666ba44f087c7c0ea72a3ab35eb2448978de3))
* **deps-dev:** bump webmock from 3.18.1 to 3.19.0 ([581846b](https://github.com/nla/nla-blacklight/commit/581846bf9b1879ca329589a9f71d4cec3c3b387a))
* **deps:** bump hiredis-client from 0.15.0 to 0.16.0 ([19c6ac3](https://github.com/nla/nla-blacklight/commit/19c6ac346603672f10489a80bff4eb7bfa153347))
* fix miniprofiler storage in remote dev env ([be8aec7](https://github.com/nla/nla-blacklight/commit/be8aec78c055b94ae9479fd642d07f45e52e0b0b))
* prepare next version ([87addf0](https://github.com/nla/nla-blacklight/commit/87addf0e486aebc5812295ff9aad3a2f1b9b85cf))
* prepare release ([dadce02](https://github.com/nla/nla-blacklight/commit/dadce0278634fa11a683432cdfbe618adc1e0246))

## [2.5.0](https://github.com/nla/nla-blacklight/compare/2.4.0...2.5.0) (2023-08-25)


### Features

* remove http-requests from prometheus stats ([0965e3f](https://github.com/nla/nla-blacklight/commit/0965e3f514b7d2b068af8eb4e1fa9a9c5412e4d9))


### Bug Fixes

* add 545 u subfield ([79d37ec](https://github.com/nla/nla-blacklight/commit/79d37ec56bef0f7cc9e3de66090386a773cbd98a))
* add caching and performance improvements ([d67e82e](https://github.com/nla/nla-blacklight/commit/d67e82e65c00dd069eede4527eaa7f76c4789cd4))
* address memory bloat ([a821d63](https://github.com/nla/nla-blacklight/commit/a821d636d088ea0185993266e2bcc65672c751ce))
* fix notes, use Nokogiri, fix scheduler ([40640c6](https://github.com/nla/nla-blacklight/commit/40640c6312b24d7a1e6eb2158fa891c6c26136be))
* integrate auth changes in nla-blacklight_common ([8dc16c2](https://github.com/nla/nla-blacklight/commit/8dc16c29eb13c3e222c984f3f49b4da3d9fef953))
* map alternate publication date ([d6ea2a4](https://github.com/nla/nla-blacklight/commit/d6ea2a4952b0e0790cc29bfeab8ca9e8674dd962))
* memoise expensive or properties called more than once ([f827df4](https://github.com/nla/nla-blacklight/commit/f827df4b530aad3033bac5b5d84c1995d2727acb))
* mock subject_ssim ([5228f4b](https://github.com/nla/nla-blacklight/commit/5228f4be34f0b40c7bcf23d50f37ad91d7b5cdaf))
* more memory leak changes ([7e4a427](https://github.com/nla/nla-blacklight/commit/7e4a4277680a5b5f7be4616fcd8a18d11db905ac))
* remove Flipper and move scheduler ([225a465](https://github.com/nla/nla-blacklight/commit/225a46553a6fbf7339d1f4fbfd8712695a3d1dae))
* turn off force_ssl and add "localhost" to hosts in staging/prod ([131236e](https://github.com/nla/nla-blacklight/commit/131236e2dcbcffa5d55a702aabd0061c034beee1))


### Miscellaneous

* add db number to delete cmd for redis clearout ([97c6cd6](https://github.com/nla/nla-blacklight/commit/97c6cd6918e02e3ccb5af24d364de358cdf9a0c5))
* clear redis using xargs to handle when large number of keys ([81c9b65](https://github.com/nla/nla-blacklight/commit/81c9b65602c17d129c610ebd66740c9a7ac356f3))
* merge changes from main branch ([1037892](https://github.com/nla/nla-blacklight/commit/1037892a9b5d6b4ea3cf5eb44c7af49b5be6af2d))
* merge changes from main branch ([92d392d](https://github.com/nla/nla-blacklight/commit/92d392de66915342944400e8e87eeff47bb393e3))
* prepae release ([32fb535](https://github.com/nla/nla-blacklight/commit/32fb535b455a530103f98a6ce31816ddd6b59b2b))
* upgrade dependencies ([ac208c5](https://github.com/nla/nla-blacklight/commit/ac208c5cdae6031f0b13ffe84539d6afaf1234e7))

## [2.4.0](https://github.com/nla/nla-blacklight/compare/2.3.4...2.4.0) (2023-08-10)


### Features

* export prometheus stats via yabeda ([4733c20](https://github.com/nla/nla-blacklight/commit/4733c20bb1ed31b59e4adfecb909d0eceb063767))
* remove rails_performance to reduce Redis usage ([f8726e0](https://github.com/nla/nla-blacklight/commit/f8726e02254428c8c0b25aa350caed2c227eb429))


### Bug Fixes

* change green text in modal to grey ([3b8d400](https://github.com/nla/nla-blacklight/commit/3b8d4007bb9f03c0bb84a0361f7260bc1743dc48))
* override range limit template to set styles ([821f487](https://github.com/nla/nla-blacklight/commit/821f48740fbe87a78fee5b1208366516abe80db4))
* reconfigure puma_worker_killer frequency ([67358e5](https://github.com/nla/nla-blacklight/commit/67358e55eaca8fd84ce3314c6e23a01292880a3c))
* remove initializer for rack-mini-profiler ([f9ff012](https://github.com/nla/nla-blacklight/commit/f9ff012dc572f40a1dc057f4b6a1e5cb7f364e96))
* remove testing code ([eeb2482](https://github.com/nla/nla-blacklight/commit/eeb2482d2ed956440cb87c4e4b34e1e11e2ff6e6))
* remove typo ([b74127a](https://github.com/nla/nla-blacklight/commit/b74127ac81c5608f1237496a67917087bc62d0c1))
* return value when no thumbnail returned ([a9b962c](https://github.com/nla/nla-blacklight/commit/a9b962cbad3a649687af7081627ac9e168b67a04))


### Reverts

* remove puma_worker_killer ([b091ccc](https://github.com/nla/nla-blacklight/commit/b091ccce7c606e4eb583528f60228babb4b8a924))


### Miscellaneous

* **deps:** bump hiredis-client from 0.14.1 to 0.15.0 ([9b7e14e](https://github.com/nla/nla-blacklight/commit/9b7e14e7b6797c9749694243e77c2e72c334f550))
* prepare release ([ff3d3d4](https://github.com/nla/nla-blacklight/commit/ff3d3d4e4ad58a18f6cc73d1bc32ff8d0202de4d))
* reconfigure puma_worker_killer ([b58e183](https://github.com/nla/nla-blacklight/commit/b58e18377cfce42eef83601b5ec8dd183c633ff1))
* upgrade dependencies ([978efe8](https://github.com/nla/nla-blacklight/commit/978efe801e011459f24adbb0533ed2eaae02b4eb))


### Code Refactoring

* make thumbnail fetch failure a warning and move to helper ([c1b9c26](https://github.com/nla/nla-blacklight/commit/c1b9c269425b8f721784a1e54825dc1b2ae7bdf0))


### Tests

* correct rubocop errors ([c00ae21](https://github.com/nla/nla-blacklight/commit/c00ae21bdaf2d88aaed6bc7ae05afdfaf1413da1))

## [2.3.4](https://github.com/nla/nla-blacklight/compare/2.3.3...2.3.4) (2023-08-08)


### Miscellaneous

* prepare hotfix ([9592718](https://github.com/nla/nla-blacklight/commit/95927189300e387b4bf07379ffbc7f072bf4e9f0))

## [2.3.3](https://github.com/nla/nla-blacklight/compare/2.3.2...2.3.3) (2023-08-07)


### Miscellaneous

* prepare hotfix ([470c589](https://github.com/nla/nla-blacklight/commit/470c58949c773ab72ea5de780da95c10fe6960d7))
* release 2.3.3 ([ada11c6](https://github.com/nla/nla-blacklight/commit/ada11c60e2515e6e0b1b5c2810f00143500917ad))

## [2.3.2](https://github.com/nla/nla-blacklight/compare/2.3.1...2.3.2) (2023-08-03)


### Bug Fixes

* remove HTML error pages ([1777b2d](https://github.com/nla/nla-blacklight/commit/1777b2dcda49acd5c155c680addb5c026360cd97))


### Continuous Integration

* bump hotfix version ([0d8a38b](https://github.com/nla/nla-blacklight/commit/0d8a38b708adc79f4bcd890a43306b42af1f24a6))

## [2.3.1](https://github.com/nla/nla-blacklight/compare/2.3.0...2.3.1) (2023-08-03)


### Bug Fixes

* bump database pool and read/write timeouts ([6c6d68c](https://github.com/nla/nla-blacklight/commit/6c6d68c057c3c13a180535ad2009b1d89b8823a3))


### Miscellaneous

* add workflow for hotfix ([1c01395](https://github.com/nla/nla-blacklight/commit/1c01395c5611e0267af1b50d39e502de6805c787))

## [2.3.0](https://github.com/nla/nla-blacklight/compare/2.2.0...2.3.0) (2023-07-27)


### Features

* adds Feedback widget to sidebar ([7a65c4a](https://github.com/nla/nla-blacklight/commit/7a65c4aa19ed76f66cd5c2b67812d6c1379c8fd1))
* display "in use" items and status ([76ca83d](https://github.com/nla/nla-blacklight/commit/76ca83d2d7e239d9634e4bfe9199f0d740c65969))
* display link to delivery conditions ([1149bac](https://github.com/nla/nla-blacklight/commit/1149bac3fa6e0f0ca4ca69dc7a2937b97db1d9f6))
* display user's checked out items ([1dc214f](https://github.com/nla/nla-blacklight/commit/1dc214f3f23b1af21fddec930675f6bba73a67bc))
* modify display for "In use" items ([e5d9f01](https://github.com/nla/nla-blacklight/commit/e5d9f01db225e9a2a21589dcde3686a7e8ac26cb))
* re-order user's request summary ([eaac452](https://github.com/nla/nla-blacklight/commit/eaac4528932f84244d07b9a849a78709775bda94))
* redirect old VuFind URLs ([bf280ab](https://github.com/nla/nla-blacklight/commit/bf280ab3fb4715350c739680836bb203512745cc))


### Bug Fixes

* Change capitalisation ([4868410](https://github.com/nla/nla-blacklight/commit/4868410f7e73429348ff534cb360a4d797107dae))
* check if requestable when building request link ([1c92610](https://github.com/nla/nla-blacklight/commit/1c926105c4b086e8f071d9402d76f4e8fc301090))
* clean ISBN and LCCN for thumbnail params ([30fca3f](https://github.com/nla/nla-blacklight/commit/30fca3fdddfe810916ec53fcb63cd457e4757393))
* clear search session when coming from a bento search ([e71eb50](https://github.com/nla/nla-blacklight/commit/e71eb503e55bb04e49a3011bcc19b0d2ff32f5c5))
* colour contrast for metadata labels ([c7e7156](https://github.com/nla/nla-blacklight/commit/c7e71567c02006c7030b48af1e66d10ec84a5e07))
* constrain image in tablet and mobile view ([cebc397](https://github.com/nla/nla-blacklight/commit/cebc3975869f6ef2a987279e791be6eb790b2b49))
* hide primary nav on tablet & mobile ([32b0e8b](https://github.com/nla/nla-blacklight/commit/32b0e8b280cfa152d71016619251156a97a6306b))
* link colours ([51d6d47](https://github.com/nla/nla-blacklight/commit/51d6d4724421627e4e784ab5b0d719f71a28e3d1))
* pluralize request limit remaining message ([06a3d8f](https://github.com/nla/nla-blacklight/commit/06a3d8fe652a4edbe0e5a57068ed53351b83cd0a))
* Rename eResources bento and update styles ([a364318](https://github.com/nla/nla-blacklight/commit/a3643187bdd35b6202f6a4b8a3249f74dfacee3a))
* replace image used for Catalogue ([567d47b](https://github.com/nla/nla-blacklight/commit/567d47b605d24d4ed015df82196af04dd7badcd3))
* reword request limit message and remove unused code ([7a29cbb](https://github.com/nla/nla-blacklight/commit/7a29cbb62505c6924a3bfba2a0a0a744319e59ec))
* Style bookmarks checkbox and positioning ([f3a59ae](https://github.com/nla/nla-blacklight/commit/f3a59aeb82ed6d1ae8e229c5a1fcbd24020ae53a))
* update colour ([66c5f03](https://github.com/nla/nla-blacklight/commit/66c5f03597e9c7a42aba58928b3f17b7cd09a8e3))
* Update URL for help ([96292de](https://github.com/nla/nla-blacklight/commit/96292de804e068570f6cfb31e7fdb561ee1e524c))
* update wording of homepage cultural message ([a0ea944](https://github.com/nla/nla-blacklight/commit/a0ea944189a83b200b7a3a5945a88e7d2e06b944))


### Reverts

* undo formatting for test.env ([351d620](https://github.com/nla/nla-blacklight/commit/351d620fa7bafdf7b529455a11f7af757ff0ac54))


### Miscellaneous

* fix webdrivers dependency ([2447a82](https://github.com/nla/nla-blacklight/commit/2447a821ada7b021dc1569b5d7a9b2246efb1db8))
* prepare for Sprint 5 ([d4f38bd](https://github.com/nla/nla-blacklight/commit/d4f38bd416d14a9f04006c4246411e289485d7e4))
* prepare Sprint 5 release ([a0f064f](https://github.com/nla/nla-blacklight/commit/a0f064fd0f2e8227864ab26e2d85e9e642c860a4))
* resolve merge conflicts ([87c33a2](https://github.com/nla/nla-blacklight/commit/87c33a2ae780c0bd17514c5d7bbc5c1ecab148b0))
* update dependencies ([0e45003](https://github.com/nla/nla-blacklight/commit/0e45003ec925b05e1fafba3175082a67c5f2259d))


### Code Refactoring

* remove bearer token from catalogue-services requests ([e24f71b](https://github.com/nla/nla-blacklight/commit/e24f71b193ca0cc7e2f81f44a8ee1c7782e86561))


### Tests

* fix tests ([b70a8d3](https://github.com/nla/nla-blacklight/commit/b70a8d3ce837ad41723efaeb63688990a8ea4932))

## [2.2.0](https://github.com/nla/nla-blacklight/compare/2.1.0...2.2.0) (2023-07-13)


### Features

* add active link to navbar ([956d748](https://github.com/nla/nla-blacklight/commit/956d748c057699442c6093c877b6faa11b53001d))
* display cancellation reason in request notes ([9ddb59a](https://github.com/nla/nla-blacklight/commit/9ddb59ab674f7e7c89aa90c8f5295bfacac334c5))
* display Publication Date in search results ([d1653e9](https://github.com/nla/nla-blacklight/commit/d1653e950f9995939f516aa90012d34157950731))
* display request limit message ([45242fe](https://github.com/nla/nla-blacklight/commit/45242febade29283233710882ad6e57252f5530f))
* remove Publish Date and Publication Year facets ([0322691](https://github.com/nla/nla-blacklight/commit/032269189a06cc11cac3bee0990ad0d7b4778fcf))


### Bug Fixes

* Add links to header ([a4e52a3](https://github.com/nla/nla-blacklight/commit/a4e52a32ffe894cbfedc6d4dbaba8dea93314048))
* add request#index action to ignored redirects locations ([8c893b7](https://github.com/nla/nla-blacklight/commit/8c893b76ed5fb2cdf17b00224623f58777a7cebb))
* check if cancellation comment is present before rendering ([a00b1e2](https://github.com/nla/nla-blacklight/commit/a00b1e27cab53dbea6cbae26c398a2e15d6c21fa))
* display custom "no request" message for each type of request ([f08771b](https://github.com/nla/nla-blacklight/commit/f08771b7708c28efcfa3495656ac1886e1ed0cc5))
* ensure time coverage date is only 4 digits long ([48e424b](https://github.com/nla/nla-blacklight/commit/48e424b3286d61ba5013284fd08984491ea3a541))
* fix check for format ([b8e3834](https://github.com/nla/nla-blacklight/commit/b8e38342bdab8e247be6c489b60d27fc33b5be7c))
* fixes MapSearch URL ([0c664f7](https://github.com/nla/nla-blacklight/commit/0c664f7f9a4963928f0f79b3401968c64e8e09cc))
* handle any errors raised when fetching holdings ([16bbf38](https://github.com/nla/nla-blacklight/commit/16bbf38a40476b348bd7367c4ad345019ddf5d49))
* make sure to check for supression ([47c15ae](https://github.com/nla/nla-blacklight/commit/47c15ae16336aeb0f13b1182768dc650b8ceca5c))
* pickup location typo ([a027aab](https://github.com/nla/nla-blacklight/commit/a027aab79fc867a407624d92523e9c9301dc9880))
* Refactor links and CSS in explore ([fd1111f](https://github.com/nla/nla-blacklight/commit/fd1111f5e719bc6adfd932ee6204fbde86cbc707))
* replace pickup images and text ([1225fa7](https://github.com/nla/nla-blacklight/commit/1225fa7b2f55a8a28eacd0cecbe1eb677f65923d))
* show result link in bento if more than 1 result ([7e215c9](https://github.com/nla/nla-blacklight/commit/7e215c9cb8be9d0999c7c5ec74ded8e3b211c5a3))
* typo in pickup location text ([84ffbe0](https://github.com/nla/nla-blacklight/commit/84ffbe0578a2080cbf362f374c3ff29a9421c846))
* typo in requestlimitReached ([3816e24](https://github.com/nla/nla-blacklight/commit/3816e244ed7875f8ad62ef751d48b6a790d686a2))


### Code Refactoring

* change Decade facet heading ([eac60b7](https://github.com/nla/nla-blacklight/commit/eac60b7cb81a3ce6efce68ee18e94f535fdd456e))
* re-order facets ([101ed77](https://github.com/nla/nla-blacklight/commit/101ed77d89c6662366661ee8935c9cb1a3367fc2))


### Miscellaneous

* prepare for next sprint ([31d8022](https://github.com/nla/nla-blacklight/commit/31d80223d29d65226e478dfab6c4d13c320f9204))
* prepare Sprint 4 release ([0525ae4](https://github.com/nla/nla-blacklight/commit/0525ae4fb72f8402d197bae6a42cc787fc96a3ee))
* remove old pickup location images ([701aac2](https://github.com/nla/nla-blacklight/commit/701aac2ebe61245a0459ad6a880f8de6f19ea1b3))
* resolve merge release back to main ([ca577e7](https://github.com/nla/nla-blacklight/commit/ca577e717776002e79da8a6b81b608c727eff443))
* update blacklight_common dependency ([728b17d](https://github.com/nla/nla-blacklight/commit/728b17d01c932751cf4a1b8bb996bbbdc3163e3c))
* update dependencies ([775a9a4](https://github.com/nla/nla-blacklight/commit/775a9a4d8b831698b298b495e68a5c1f8fb1df85))
* update nla-blacklight_common dependency ([eb8aac3](https://github.com/nla/nla-blacklight/commit/eb8aac392438b628fe014f489358d0552c03a28a))
* upgrade Bundler version in Gemfile.lock ([78ec738](https://github.com/nla/nla-blacklight/commit/78ec738042497484a75eded352399f2fc838e198))

## [2.1.0](https://github.com/nla/nla-blacklight/compare/2.0.1...2.1.0) (2023-06-30)


### Features

* add Requests menu link and dummy page ([e9023c1](https://github.com/nla/nla-blacklight/commit/e9023c1a80ea1f62031502dc8820e55e13af0bfa))
* adds Sign up link to header nav ([e3528b2](https://github.com/nla/nla-blacklight/commit/e3528b246e1aa2715796e9b5dea7bde6a93deea3))
* display thumbnails in catalogue bento search results ([e92e2c8](https://github.com/nla/nla-blacklight/commit/e92e2c8ec2081132675b0940b496309b4d16b4e2))
* ensure login from bento results redirects back to all search results ([296d8c6](https://github.com/nla/nla-blacklight/commit/296d8c653ffb56afdfd69e0f87f3703b0dbe9e4b))
* hide requesting for online or electronic resources ([148a525](https://github.com/nla/nla-blacklight/commit/148a52558e9981cc2522138930ae12ae38c42772))
* implement multiple collections ([7328205](https://github.com/nla/nla-blacklight/commit/7328205ee3d16a7968a33d7072cb90df3ed0c432))
* lazy load holdings data ([e7aa9ed](https://github.com/nla/nla-blacklight/commit/e7aa9ed01c71cf0ab624528f39c8951a28661fc6))
* lazy load thumbnails ([ef27fad](https://github.com/nla/nla-blacklight/commit/ef27fad07f357935608b694f24a2da7e334b4da8))
* restyle bento and thumbnail loading states ([e676875](https://github.com/nla/nla-blacklight/commit/e676875d05bb6551c5ab4e6d9662c23ddf3df9f1))
* restyle loading state of request holdings ([ab9364c](https://github.com/nla/nla-blacklight/commit/ab9364c5befc5494c9610f2e6e922333ce6f0a0f))


### Bug Fixes

* add catalogue card and image on homepage ([f183198](https://github.com/nla/nla-blacklight/commit/f1831981b25438aa6bdd1b1ea777d6f6625f37db))
* change bento search page header ([7a5baab](https://github.com/nla/nla-blacklight/commit/7a5baab27fa5f5773ae3e4af1a8281f97247be38))
* change display of “Start over” and “Back to search” ([20e9275](https://github.com/nla/nla-blacklight/commit/20e9275101d14124f9977c2935d1243c1a56b196))
* change spacing to keep buttons in one line on tablet view ([c98f69f](https://github.com/nla/nla-blacklight/commit/c98f69fb8a01904d8b581ffc84f3a2d2ecd69d29))
* constrain images to fit in 500x500px space (especially for panoramic images) ([0bed209](https://github.com/nla/nla-blacklight/commit/0bed209a1b7770d0c2f86673f4ec4b2ddb87ee43))
* exclude custom devise controllers from storable location ([7af7b24](https://github.com/nla/nla-blacklight/commit/7af7b245115cbeb1320afbf2da777b1066e4ddc7))
* exclude thumbnail routes from Devise location store ([3e2b24e](https://github.com/nla/nla-blacklight/commit/3e2b24e85ea4a8f4a98dfd44e0ca96f6dd3ce710))
* fix tests and HTML ([55e35b0](https://github.com/nla/nla-blacklight/commit/55e35b03cac531dd2b4f55127658bf3ae7345bff))
* fix thumbnail sizing for non-DLIR thumbnails ([67c35a6](https://github.com/nla/nla-blacklight/commit/67c35a64ab265e66c13b8c982de020a81c0f4090))
* hide Request Item when disabled ([b00447b](https://github.com/nla/nla-blacklight/commit/b00447b748ba8c9a4affa77013043acb06db0341))
* hide requesting for electronic and online resources ([837879d](https://github.com/nla/nla-blacklight/commit/837879d61ba18a6f39f90577edc9d20aa228e097))
* implement requests summary for user ([050cd3e](https://github.com/nla/nla-blacklight/commit/050cd3e38a41fce849bba60d0c85679db2994aad))
* load thumbnails in correct size based on view ([a24f9ff](https://github.com/nla/nla-blacklight/commit/a24f9ff8e22e9628b7f8b8bdf182cb704ac01132))
* remove duplicate content  on catalogue specific  homepage ([13f86b3](https://github.com/nla/nla-blacklight/commit/13f86b3785fe0b96c28a8bd81468d2b67c1b8bdd))
* rename pickup location images ([03cbab5](https://github.com/nla/nla-blacklight/commit/03cbab532d8de5c66e181de9a26d169d2ef35988))
* specify "all_fields" to fix bento search results ([10a755a](https://github.com/nla/nla-blacklight/commit/10a755a973072593c83c25b4eec3438a7bd900a4))
* styling of thumbnail size ([498804d](https://github.com/nla/nla-blacklight/commit/498804d3b8927684925bcc73a51b5b010b47b208))
* take into account record without a format ([d30fc0d](https://github.com/nla/nla-blacklight/commit/d30fc0db4ce17cce15c8896a1d298ce04107f875))
* UI changes for bento ([320fdca](https://github.com/nla/nla-blacklight/commit/320fdca9489fe6ddeb1138332fbf54ef9cdafb75))
* UI on request list page ([f05d628](https://github.com/nla/nla-blacklight/commit/f05d628e182ab9cf04ae6a687fc5ad312be949bf))
* update bento results UI for tablet. Result summary pills ([d9c1196](https://github.com/nla/nla-blacklight/commit/d9c11968fe44f8af8a0950c9b4491be8cdfde58f))
* update logos & text ([842d9af](https://github.com/nla/nla-blacklight/commit/842d9af1a1ef5ac4ecea263bccf9a776f62171af))
* update semantic field for "format" ([9046a9d](https://github.com/nla/nla-blacklight/commit/9046a9dc07a659b8528c168a481a38cb24e62a10))
* verify if eresources config is valid JSON before caching ([966dd94](https://github.com/nla/nla-blacklight/commit/966dd947eb98531e282c76d92453ed12f7c50660))


### Reverts

* restore format semantic field ([9e06bda](https://github.com/nla/nla-blacklight/commit/9e06bda3f119b52d2c0c41667938e8919559ee50))


### Styles

* fix styling of thumbnails ([e13587b](https://github.com/nla/nla-blacklight/commit/e13587b542e8541a3f2c1c0456bcf2a013262989))


### Code Refactoring

* get thumbnails from thumbnail-services ([6dac437](https://github.com/nla/nla-blacklight/commit/6dac437571f26a521720d62c440681ad092b5cca))
* make requests routing more Rails-centric ([8c62689](https://github.com/nla/nla-blacklight/commit/8c62689638e742c9de00bba1b02abd131ff334f9))
* use stimulus controller for related records icon hover state ([2d8ed33](https://github.com/nla/nla-blacklight/commit/2d8ed330f47a171ae248b6f0c16445e41abb2a89))


### Tests

* fix pickup location thumbnail tests ([f0ea4a4](https://github.com/nla/nla-blacklight/commit/f0ea4a4a9b696e7fe89f117d01a7471ed72a08db))
* fix related records tests ([488c10a](https://github.com/nla/nla-blacklight/commit/488c10a94a8b58653955a0438144eb6400f54874))
* fix tests ([fe96ab0](https://github.com/nla/nla-blacklight/commit/fe96ab0878c2e5bf42c4065020460f6c28232425))
* fixes test ([4951a4d](https://github.com/nla/nla-blacklight/commit/4951a4d94f9ffd2dde94548562338a498f6d5678))


### Continuous Integration

* add release workflow for sprint 3 ([8d38a72](https://github.com/nla/nla-blacklight/commit/8d38a7291f8bd5a9df61d3dc44c1ba0b82b39668))
* allow release branches to trigger verify workflow ([cdafac0](https://github.com/nla/nla-blacklight/commit/cdafac077d6b32b5831c5c0e36b18107c8356139))
* fix release-sprint-3 workflow ([41d9a83](https://github.com/nla/nla-blacklight/commit/41d9a83ef5792c185bb9a508e169855dee57b24f))
* fix verify workflow trigger ([401afde](https://github.com/nla/nla-blacklight/commit/401afdedfd30910a01e919f0cfe415ca408a9d19))


### Miscellaneous

* cherry pick fix for BLAC-396 into release ([2b1c56a](https://github.com/nla/nla-blacklight/commit/2b1c56a8256b79060bcdcfe95682411f8eead2c5))
* extract Search header to localisation config ([7843483](https://github.com/nla/nla-blacklight/commit/7843483f4f36fbfd4754d6b4956692f782c7f167))
* finalise sprint 3 release ([54317dd](https://github.com/nla/nla-blacklight/commit/54317dd7a591e01edbd29bfaa1fb9e2cbd6ca38f))
* fix release-sprint-3 workflow ([dd1be27](https://github.com/nla/nla-blacklight/commit/dd1be276c772d1122835e7ef7ecf511951853bd2))
* rename parent_id_ssi and collection_id_ssi fields ([fcd6875](https://github.com/nla/nla-blacklight/commit/fcd687589f322e9bdf51fe06678117c5292f3d12))
* upgrade bundler ([b92982a](https://github.com/nla/nla-blacklight/commit/b92982aa4fb0daac784b31bcea75498afc125795))
* upgrade deps to address CVE-2023-28362 ([4940005](https://github.com/nla/nla-blacklight/commit/4940005f620d483b269751e3693acc6e1dc41ea8))
* upgrade nla-blacklight_common dependency ([f8d09aa](https://github.com/nla/nla-blacklight/commit/f8d09aa44d00abedf18a1ba24081342a2c5d8102))

## [2.0.0](https://github.com/nla/nla-blacklight/compare/1.1.0...2.0.0) (2023-06-13)


### ⚠ BREAKING CHANGES

* use nla-blacklight_common

### Features

* add single search engine controller action ([a6803b2](https://github.com/nla/nla-blacklight/commit/a6803b21f0c8ff5079690c6fa1a2cd6ca841c1bc))
* add skeleton loading animation ([1604483](https://github.com/nla/nla-blacklight/commit/1604483548c52f49bafe20caced9b2044280a932))
* cache catalogue services access token ([b917e0f](https://github.com/nla/nla-blacklight/commit/b917e0f2740dee9cd44d7eaa818c067750d7a79e))
* use nla-blacklight_common ([30ffe14](https://github.com/nla/nla-blacklight/commit/30ffe14b5f6496ecd0b4d88826c8a9bc23d74583))


### Bug Fixes

* add lower bar to header for application name ([2e99807](https://github.com/nla/nla-blacklight/commit/2e998070c7dc551af97d2ab1a125f49bac48200e))
* change styling of bento headings ([00a402f](https://github.com/nla/nla-blacklight/commit/00a402f358f6272fd2f2ba014be52ef5d531c612))
* determine totalss based on visible elements in bento results ([fe417c6](https://github.com/nla/nla-blacklight/commit/fe417c66b8441d3c9e961d0ec8421b40ad53df27))
* fix display of thumbnails ([99a146b](https://github.com/nla/nla-blacklight/commit/99a146b4b4b3f5b9d4ee0878d9594ad770746a0b))
* fix reference to "#clean_isn" ([476f36a](https://github.com/nla/nla-blacklight/commit/476f36a65d4077048a599105f06a5bcea020c2be))
* fix references to `#isbn_list` and `#clean_isn` ([ba17b50](https://github.com/nla/nla-blacklight/commit/ba17b50ec511a2c685ba6eb39c49c217b9a05a02))
* fix styling of bento search skeleton ([944b678](https://github.com/nla/nla-blacklight/commit/944b67802f8b616b41f9b2e6ed408254545d6f97))
* fix verify workflow ([110b04b](https://github.com/nla/nla-blacklight/commit/110b04b05bc0ca42016f32a5f310f75e1ff60785))
* hide button for single bento results ([4d0ad06](https://github.com/nla/nla-blacklight/commit/4d0ad067ffeca069fe18b8be8f16cd6ba388f9a6))
* refine layout so image is better sized and update text ([e58ad3a](https://github.com/nla/nla-blacklight/commit/e58ad3a58f04f094bfc6a5d137e176e41659ab12))
* remove expand on bottombar ([5844f4d](https://github.com/nla/nla-blacklight/commit/5844f4d58b7ef2d14b7bc4756f48a95e309981c2))
* remove sticky header rule for “environment bar” ([c581685](https://github.com/nla/nla-blacklight/commit/c581685ddabf301ae9ca4c5d6cf9ad805852c71f))
* replace library card image with newer ([6977dbe](https://github.com/nla/nla-blacklight/commit/6977dbec3708e7ae269e682f8da0c8fea0672533))
* reposition and style navbar actions ([904e149](https://github.com/nla/nla-blacklight/commit/904e149972aebddba7a40ecdb792a9a3ede1dd73))
* use bookmark nav partial and style ([bb902aa](https://github.com/nla/nla-blacklight/commit/bb902aadbb5c78aebe256e8620271dc04d3f58f4))


### Continuous Integration

* add Redis to verify workflow ([76f7dea](https://github.com/nla/nla-blacklight/commit/76f7dea6998b97f1f865514e18d568b4d6acfd16))
* create hotfix release workflow ([1c8eb9d](https://github.com/nla/nla-blacklight/commit/1c8eb9d854e8589bd965541baefd2d335e6d9d6d))
* modify simplecov configuration ([b3e66dc](https://github.com/nla/nla-blacklight/commit/b3e66dc5e4b60dbecc94f20eeef7b97b2629746f))


### Build System

* add env flag to nla-deploy.sh to turn on dev caching ([95319e7](https://github.com/nla/nla-blacklight/commit/95319e704659c41e8b595ffd1a9c6c3b6b06af3e))
* change bundle config for jobs to static number ([6b1344b](https://github.com/nla/nla-blacklight/commit/6b1344ba0749d3eefb6aa75ebefa0c41f60cff61))
* make cuprite optional for Capybara specs ([e7c78d0](https://github.com/nla/nla-blacklight/commit/e7c78d08e914430f4d866dc0d15b8a688a0e9600))


### Code Refactoring

* convert some bento controller tests to system tests ([1857897](https://github.com/nla/nla-blacklight/commit/185789774d0468efa96bf5e96bf60da27a5102a7))
* create component for bento search results ([9f9aaae](https://github.com/nla/nla-blacklight/commit/9f9aaae8595af40fd4712625f213dae1be0cae96))
* create component for bento search totals ([58178bb](https://github.com/nla/nla-blacklight/commit/58178bbd31b131fa642b9ba1a8d478868346e102))
* have requesting errors be handled by 500 page ([e38a786](https://github.com/nla/nla-blacklight/commit/e38a786219d63fd739a01ee76a45f443e6f8041b))
* move thumbnail cache from page to service ([35b0ea6](https://github.com/nla/nla-blacklight/commit/35b0ea634820249bc71fe4b4c3efdf4b1503ba5c))
* refactor display of holdings error on catalogue record page ([9887dcf](https://github.com/nla/nla-blacklight/commit/9887dcfbd79cceceeb5f0c96578bf581e22373ba))
* reposition navbar actions ([95b529a](https://github.com/nla/nla-blacklight/commit/95b529af22465e963bc4e1f71799413476b3f158))
* revert and comment out changes to bento search ([b265a4f](https://github.com/nla/nla-blacklight/commit/b265a4fd15361956f2557e394862c94e9c9f4727))
* update wording on error pages ([e40eb32](https://github.com/nla/nla-blacklight/commit/e40eb322d52bb7e3d54230500f50aff58069f686))
* use stimulus to lazy load bento results ([426d157](https://github.com/nla/nla-blacklight/commit/426d157521d6fbc8e4a280287f0abb4d012bc834))


### Tests

* add tests for access token caching ([6063446](https://github.com/nla/nla-blacklight/commit/60634466132df086283d8576cdf2c1610c8cb0f4))
* add tests for bento components ([cc72210](https://github.com/nla/nla-blacklight/commit/cc7221013f3e1fe1a2675153eac47cbe407b69ed))
* fix tests ([b3fd8d3](https://github.com/nla/nla-blacklight/commit/b3fd8d355464a34102245f966a743a98e4bbb705))
* make Capybara wait for catalogue search result card ([1293fef](https://github.com/nla/nla-blacklight/commit/1293fef86488065585b5697c5ccf0a95e883166f))


### Miscellaneous

* add simple performance monitoring ([60e99fe](https://github.com/nla/nla-blacklight/commit/60e99fe98c0db56b67f518894098ab3c990c1fa9))
* delete JavaScript console.out ([2b9032f](https://github.com/nla/nla-blacklight/commit/2b9032f0bf0df6e72e17afb4b70335ccf3a90821))
* point dependencies back at main/master branch ([85a47d3](https://github.com/nla/nla-blacklight/commit/85a47d3ea795af4478e2ea435755b1442523c29b))
* prepare release ([27360de](https://github.com/nla/nla-blacklight/commit/27360de82ebd27b96a0470075d5141fea2162659))
* upgrade catalogue-patrons dependency ([0351279](https://github.com/nla/nla-blacklight/commit/0351279bbf1a87a8fae26c9ff43c9116555c589b))
* upgrade dependencies and fix inclusion of Stimulus controllers ([b54904a](https://github.com/nla/nla-blacklight/commit/b54904ae9a741c9bc751921543c9c0d7f77e2e5f))
* upgrade solr adapter dependencies ([0f9c644](https://github.com/nla/nla-blacklight/commit/0f9c64479ea0cca186f6a758afd5b254a95318e9))
* upgrade version of bundler in Gemfile.lock ([a845b42](https://github.com/nla/nla-blacklight/commit/a845b42b5563411f75821a013846bd998e8787b0))

## [1.1.0](https://github.com/nla/nla-blacklight/compare/1.0.4...1.1.0) (2023-05-30)


### Features

* add some generic delivery times message ([0d78c8c](https://github.com/nla/nla-blacklight/commit/0d78c8cfea62a5c9a2ea3e3981e353407eae7f5a))
* implement request form ([c64ce95](https://github.com/nla/nla-blacklight/commit/c64ce955aad958ac61a87af9c1c4a1a913476def))
* replace EDS and blacklight bento search engines ([3663e54](https://github.com/nla/nla-blacklight/commit/3663e547c7b2a147fda217f4d13605a86a728a4c))
* replace EDS gem with plain HTTP requests to EDS API ([270b78e](https://github.com/nla/nla-blacklight/commit/270b78ee385520fbe4625a9469ca33ce77de00c1))
* truncate titles to 175 characters on index search page ([8bfbbe8](https://github.com/nla/nla-blacklight/commit/8bfbbe885a3b12b68f938d88e87b52c23cbfd73b))


### Bug Fixes

* disable catalogue record actions component ([2acee32](https://github.com/nla/nla-blacklight/commit/2acee3230e796f1ef75a2da0d6a1c8a4bdd1e89f))
* fix catalogue-patrons version number ([afd2bc3](https://github.com/nla/nla-blacklight/commit/afd2bc39611fb6a6819b267e4faeb933d3d2aa82))
* fix config for EDS bento title search ([69ab7fa](https://github.com/nla/nla-blacklight/commit/69ab7fae88eee50d39296ba46bd6589db22ba87f))
* fix display of global message on home page ([5cb6b53](https://github.com/nla/nla-blacklight/commit/5cb6b53a233cd555387fb7eb1f51bed05c5a0ea4))
* fix EDS search code and truncate title links ([19235fe](https://github.com/nla/nla-blacklight/commit/19235fe94b347af14494e18dcba30d20ed02c20e))
* fix nil error ([783feb1](https://github.com/nla/nla-blacklight/commit/783feb1b61855f186c2dc2076a14f1670d0d8f88))
* fixes as per code review comments ([790e77a](https://github.com/nla/nla-blacklight/commit/790e77a9eb7431028157ee792a2574781716077a))
* fixes linking of images on search results page ([7df8dca](https://github.com/nla/nla-blacklight/commit/7df8dca14c93d21b5155a73cb4c1e3e085ab9762))
* integrate login changes into Blacklight ([6aeaf97](https://github.com/nla/nla-blacklight/commit/6aeaf9740dc224cdc1e26d14adeec5c85342e34f))
* isolates request for bearer token for catalogue services API ([9c4d1b4](https://github.com/nla/nla-blacklight/commit/9c4d1b44b3199a519cd976e6df8193ea7d90737b))
* refactor EDS bento search engine ([1334380](https://github.com/nla/nla-blacklight/commit/13343804d6127a799b07fe6d30e60c91a49d0e34))
* reinstate usage of EDS API gem ([8a3878d](https://github.com/nla/nla-blacklight/commit/8a3878db69a72cc6d724445cadca703537bfbb35))
* removes duplicated title from search results index ([f4e4d44](https://github.com/nla/nla-blacklight/commit/f4e4d44131a16db450436920f657b8d225a2a5e3))
* show the global message for catalog with search params ([c1fe252](https://github.com/nla/nla-blacklight/commit/c1fe252fad4622748d352345d199ec8f9213cae7))


### Code Refactoring

* remove extra request routes ([2d35bd8](https://github.com/nla/nla-blacklight/commit/2d35bd86ca44f49bf9ec5dae5aa1487d492031f1))


### Tests

* add more requesting tests ([7ffeb22](https://github.com/nla/nla-blacklight/commit/7ffeb229016d3d6d1dbf24350afc3d342c8a76e2))
* add test for request success message ([ae01d2e](https://github.com/nla/nla-blacklight/commit/ae01d2e2dec9a327cc54c4822c8902677ccdd97d))
* add tests for pickup location and image ([98c953e](https://github.com/nla/nla-blacklight/commit/98c953e217ce2c858ca19d4a150a164155c5ca55))
* add tests for UrlHelper ([914b348](https://github.com/nla/nla-blacklight/commit/914b348bcb2d611c61861d897f5017197cdfde7e))
* adds tests for request component and helper ([c950455](https://github.com/nla/nla-blacklight/commit/c9504551d3e055baf4f158a721110cf12a77b032))
* fix FA search mock ([6f8fdb7](https://github.com/nla/nla-blacklight/commit/6f8fdb7babdabba31cf0036ca945187534cf9100))
* fixes tests ([e92e45c](https://github.com/nla/nla-blacklight/commit/e92e45c9005d5a183a3420b383e128044cfe3226))
* set Content-Type header so Faraday will parse response as JSON ([d30b683](https://github.com/nla/nla-blacklight/commit/d30b683c0efb52042c68ed423d7292074de063b8))


### Miscellaneous

* integrate renaming of staff shared login ([19db19e](https://github.com/nla/nla-blacklight/commit/19db19ea38bb962464e35933e2c19c9ca0987155))
* prepare release ([08aab4f](https://github.com/nla/nla-blacklight/commit/08aab4f9250bc683bdf3e2ea600ebebf725b3474))
* resolve hotfix changes into main ([af11f0d](https://github.com/nla/nla-blacklight/commit/af11f0d2063b3db60da94220e6204e02b6ae8145))
* resolve hotfix changes to main ([f162044](https://github.com/nla/nla-blacklight/commit/f16204457173ce408a9df402afc4ba6c5cb58dce))
* update bin/setup script bundler section ([5a70719](https://github.com/nla/nla-blacklight/commit/5a70719f97af1c8ff879d0d7544ec7c2b1e98566))
* update blacklight solr files to be same as solr-tove ([6478e56](https://github.com/nla/nla-blacklight/commit/6478e56db1319acbd5ef1c742b61e47d9308b9c4))

## [1.0.2](https://github.com/nla/nla-blacklight/compare/1.0.1...1.0.2) (2023-05-12)


### Bug Fixes

* remove advanced search button from bento search page ([fa3676d](https://github.com/nla/nla-blacklight/commit/fa3676d8d81f9502a30da0d77dd97549b46e7170))

## [1.0.1](https://github.com/nla/nla-blacklight/compare/1.0.0...1.0.1) (2023-05-11)


### Bug Fixes

* display sidebar when showing search results on root_path ([547d05e](https://github.com/nla/nla-blacklight/commit/547d05e6ba8ecde913360556ca83c394c057ce9b))
* re-hide search bar on advanced search page ([38ae24e](https://github.com/nla/nla-blacklight/commit/38ae24ebb06f113cec39db4b554ab79f73673876))

## 1.0.0 (2023-05-11)


### ⚠ BREAKING CHANGES

* separate database config for users and sessions
* separate database config for users and sessions

### Features

* account for NED items and mobile styling of buttons ([b6f8cb5](https://github.com/nla/nla-blacklight/commit/b6f8cb583565f589006bf80f7e1cc52a104b7554))
* add Former Title to catalogue record page ([e78eefb](https://github.com/nla/nla-blacklight/commit/e78eefbd406fcb86f86c4e76b6eb777c5e503e29))
* add Former Title to catalogue record page ([d2a5409](https://github.com/nla/nla-blacklight/commit/d2a5409f40012d93dcf8d00db246efb78af7367b))
* add global message display ([9c581b9](https://github.com/nla/nla-blacklight/commit/9c581b9bcc145497731b0d5c7af8eea069d869a2))
* add Google Books preview icon ([65c4316](https://github.com/nla/nla-blacklight/commit/65c4316758b7e228ecdf283d33092c3ffd3a25d0))
* add navigation bar for bento search results ([6564f1f](https://github.com/nla/nla-blacklight/commit/6564f1fdcc0865da4292cec8eba7c227df8dbd73))
* add navigation bar for bento search results ([5a5e35d](https://github.com/nla/nla-blacklight/commit/5a5e35d524caf9f4786a29e96c8a9ba4b6cb9c32))
* adds Also Titled to catalogue record page ([99d793d](https://github.com/nla/nla-blacklight/commit/99d793de5b0106a946de5d6d94e0eb0ffb0fde04))
* adds Also Titled to catalogue record page ([bbe0db3](https://github.com/nla/nla-blacklight/commit/bbe0db30b385c4274b30decabc1c08fd116909a0))
* adds Form/genre to catalogue record page ([72c8886](https://github.com/nla/nla-blacklight/commit/72c8886d09ceb48b294d95931507c46d828996a1))
* adds Form/genre to catalogue record page ([4760319](https://github.com/nla/nla-blacklight/commit/4760319116d107d8399b5725e79bfdf134183a5e))
* adds frequency to catalogue record page ([009f155](https://github.com/nla/nla-blacklight/commit/009f155e86b2fe91e99d9105d03cdc98b22fc76b))
* adds frequency to catalogue record page ([b197a77](https://github.com/nla/nla-blacklight/commit/b197a77d82b990b71856398930cf6ac11ade61c3))
* adds Has Supplement to catalogue record page ([d0f8b15](https://github.com/nla/nla-blacklight/commit/d0f8b15dcb9bc5b1bedea3f4c80c39c990b6a34c))
* adds Has Supplement to catalogue record page ([8786c4d](https://github.com/nla/nla-blacklight/commit/8786c4d8300f0eee92162a4dcbd48b6515948d7a))
* adds index/finding aid notes to catalogue record page ([153f609](https://github.com/nla/nla-blacklight/commit/153f609040aef98a0eada65e22ab42b91806469f))
* adds index/finding aid notes to catalogue record page ([fc1e07f](https://github.com/nla/nla-blacklight/commit/fc1e07fcefac0d80b7a5fc967f3c14107e2167a8))
* adds Later Title to catalogue record page ([f4e4dc9](https://github.com/nla/nla-blacklight/commit/f4e4dc98ec83dd2d98c149208f071677a369d618))
* adds Later Title to catalogue record page ([9df7c9b](https://github.com/nla/nla-blacklight/commit/9df7c9b366ffe9ecaa4645d11c8560c80f70bd1b))
* adds occupation to catalogue record page ([ca7be0f](https://github.com/nla/nla-blacklight/commit/ca7be0f5355c035e3c8f922ad8d48a6a9f392034))
* adds occupation to catalogue record page ([a9c1795](https://github.com/nla/nla-blacklight/commit/a9c1795bb92f7dc8014c2f0f303ee4b679744d1b))
* adds Other Authors to catalogue record page ([16643fa](https://github.com/nla/nla-blacklight/commit/16643faf8ebed91cf4f132564e88a5f719853166))
* adds Other Authors to catalogue record page ([fb8508c](https://github.com/nla/nla-blacklight/commit/fb8508cfdf36706caa539b8d4e95eb5d0159f91d))
* adds Place to catalogue record page ([3fbc134](https://github.com/nla/nla-blacklight/commit/3fbc134b7232f929fdaa6220fc0556dc4facf7ef))
* adds Place to catalogue record page ([d349a7f](https://github.com/nla/nla-blacklight/commit/d349a7f308aaa4e30deac921bc808980ef359167))
* adds previous frequency to catalogue record page ([ba67800](https://github.com/nla/nla-blacklight/commit/ba678004442c3f5158d67683593fc88db197e0c5))
* adds previous frequency to catalogue record page ([0b9197e](https://github.com/nla/nla-blacklight/commit/0b9197eff46e592a6750b38bc36efe333f13f1c4))
* adds Supplement To to catalogue record page ([4c3e5e5](https://github.com/nla/nla-blacklight/commit/4c3e5e51624846597e41a6243ef355fe0dc3726f))
* adds Supplement To to catalogue record page ([4dcd530](https://github.com/nla/nla-blacklight/commit/4dcd530ea3a1e4e70df929ce3ee8d01b462fcf56))
* adds Terms of Use to catalogue record page ([f112cf4](https://github.com/nla/nla-blacklight/commit/f112cf462331278e021dcb85bd682b8be5f74f50))
* adds Terms of Use to catalogue record page ([356e58e](https://github.com/nla/nla-blacklight/commit/356e58ec1e9d620df6ddfd88402fc8aad7bab9c3))
* bento search ([7d58a7d](https://github.com/nla/nla-blacklight/commit/7d58a7dc0c6da0e882419476942f0037492f2d86))
* bento search ([1407fbc](https://github.com/nla/nla-blacklight/commit/1407fbc49a24f5a4da7ee1952b1076dfe028f5ae))
* changes title of More Like This component to Similar Items ([0f4214e](https://github.com/nla/nla-blacklight/commit/0f4214e8f57b0ed9add45e1d176aef2c3d312776))
* changes title of More Like This component to Similar Items ([d763604](https://github.com/nla/nla-blacklight/commit/d763604c8b6906a0682dc0b3adf805e83c93073b))
* configure all items link for finding aids and EDS ([5940232](https://github.com/nla/nla-blacklight/commit/594023290a46e309e5924951000e3d302910b113))
* configure all items link for finding aids and EDS ([a031eb0](https://github.com/nla/nla-blacklight/commit/a031eb01371b9203d7fb4e7a6b886c82ed0926eb))
* first cut of Explore/More Results component ([d92bd52](https://github.com/nla/nla-blacklight/commit/d92bd522d0c8661415e192ca12c0a15db9d7ba4c))
* implement LibraryThing link in Explore component ([b0a0e3a](https://github.com/nla/nla-blacklight/commit/b0a0e3ac2d8ded2eb427a17fc9ebe18ff6b6bf49))
* implement NLA Shop link in Explore sidebar ([539c1a4](https://github.com/nla/nla-blacklight/commit/539c1a414fd173d613953d255b9af930cd1f6db5))
* implement offsite urls ([bb66f55](https://github.com/nla/nla-blacklight/commit/bb66f5599616c842e000319aaebf396f2eb0af7b))
* implement offsite urls ([7026127](https://github.com/nla/nla-blacklight/commit/7026127878bd5a0bb72ad67e85c5989f5a6cb19a))
* implement request action buttons ([c7a5e9d](https://github.com/nla/nla-blacklight/commit/c7a5e9daf4b7bc91e30adaed7302d98233d6be48))
* implement thread pool for bento search ([6822a21](https://github.com/nla/nla-blacklight/commit/6822a2149e00dc63bf76e67fef563dcec1f7a923))
* implement thread pool for bento search ([d2dda0d](https://github.com/nla/nla-blacklight/commit/d2dda0d11fa7b1f173a3a1c7413325f344961df4))
* integrate backchannel logout changes and fix bookmarks ([bb91e5b](https://github.com/nla/nla-blacklight/commit/bb91e5b45f7f2f5c560a8fc56be8f79ad16e11f4))
* integrate catalogue-patrons ([d6ac30a](https://github.com/nla/nla-blacklight/commit/d6ac30a39e894ed3a8eadede07b9492e49a57792))
* integrate catalogue-patrons ([f397a65](https://github.com/nla/nla-blacklight/commit/f397a65af9e3a43484216aed57ee9441097996c4))
* integrate reimplemented feature flags and location checks ([ac7e7c7](https://github.com/nla/nla-blacklight/commit/ac7e7c786b77762af7acd838a7133b3de3f20bf7))
* integrate separate staff realms for SPL and SOL ([a8422b9](https://github.com/nla/nla-blacklight/commit/a8422b9719b6ce57c439876bf4d1928e795f6df8))
* integrate separate staff realms for SPL and SOL ([b1d7a96](https://github.com/nla/nla-blacklight/commit/b1d7a967fc2d24f38ac24e3888d66ed3220d8e10))
* integrate staff backchannel logout changes ([c1cb20c](https://github.com/nla/nla-blacklight/commit/c1cb20c9bec2be867def996cacc95e5afb9ccc21))
* integrate staff backchannel logout changes ([e6e6d4b](https://github.com/nla/nla-blacklight/commit/e6e6d4b423dde7a25a293de377d64bc1e853865a))
* links supplement titles to title search ([98fdad0](https://github.com/nla/nla-blacklight/commit/98fdad02129bdddfc4e60dad9db55cd09e3b0b34))
* links supplement titles to title search ([bf9b3d2](https://github.com/nla/nla-blacklight/commit/bf9b3d2d551d83ffbc3c05919c2432c6ba2dbd9c))
* move caching from file system to Redis ([9772657](https://github.com/nla/nla-blacklight/commit/97726576cfc8bf3fbfe13630597eba213e7f2a68))
* move caching from file system to Redis ([d7ef13e](https://github.com/nla/nla-blacklight/commit/d7ef13edae305f3a5f87d3c586421def887142e8))
* move test into locale config ([f864feb](https://github.com/nla/nla-blacklight/commit/f864feb0cb5750d7417db8ea44774bca338d05ac))
* move test into locale config ([fbe46e9](https://github.com/nla/nla-blacklight/commit/fbe46e928a139c8edaec8dc184706962cd6c570f))
* number bento search results ([d4f2fdd](https://github.com/nla/nla-blacklight/commit/d4f2fdd72d190c37db522e988d8d78f4daaa27a9))
* number bento search results ([46beadc](https://github.com/nla/nla-blacklight/commit/46beadc71d1c092816c614e6b87d320e7a317fb3))
* only show staff login links in staff network ([c34acb0](https://github.com/nla/nla-blacklight/commit/c34acb0fd44904c2caf4ee0a3f82a1cb74a9a7dd))
* only show staff login links in staff network ([98ceee6](https://github.com/nla/nla-blacklight/commit/98ceee6c306efda1f2fd6cf239c46b41009116c1))
* override Blacklight Advanced Search template to remove sort ([d77aebb](https://github.com/nla/nla-blacklight/commit/d77aebbf7af1931e1df3a3b1d585898f8bcf980a))
* override Blacklight Advanced Search template to remove sort ([88d8641](https://github.com/nla/nla-blacklight/commit/88d8641d8b6bfb1358ffb469500a912a0384a029))
* perform bento searches in parallel ([66fa8ee](https://github.com/nla/nla-blacklight/commit/66fa8ee1bd42062746d99f010112fccf54d223a2))
* perform bento searches in parallel ([73779a0](https://github.com/nla/nla-blacklight/commit/73779a069f431f0e9ebfbe4e1fa5234b669b1fa1))
* reconfigure allowed hosts ([bfd867f](https://github.com/nla/nla-blacklight/commit/bfd867f3382b7cad00cc1e6f6d7f385ec595a620))
* remove "Beta feedback" link in header ([79efa3b](https://github.com/nla/nla-blacklight/commit/79efa3baff71dff17da15aacc45cd52c3c4d2578))
* remove facets from home page ([769ed0c](https://github.com/nla/nla-blacklight/commit/769ed0c682a17bc5877049d3c9b67a44c17960f4))
* remove search bar from Advanced Search page ([751b797](https://github.com/nla/nla-blacklight/commit/751b79738420877524b456a569d17a9d5c877d32))
* remove search bar from Advanced Search page ([d5f1fe8](https://github.com/nla/nla-blacklight/commit/d5f1fe874424e5670295c6d74ac47591b2ff6c21))
* replaces home page search box with bento search box ([f87010e](https://github.com/nla/nla-blacklight/commit/f87010e4287ce6cc4d11a4e281459f6dec9ed725))
* separate database config for users and sessions ([b56286b](https://github.com/nla/nla-blacklight/commit/b56286b9db2759ef4c3982701dff339d3bf6eb5d))
* separate database config for users and sessions ([655070c](https://github.com/nla/nla-blacklight/commit/655070ce06f668d7332bc54a8c35200c5ef9f1f4))
* update config example for Keycloak ([31c3c20](https://github.com/nla/nla-blacklight/commit/31c3c20419ece081afae89de97c4d1a9a2cc4587))
* update config example for Keycloak ([b33ec01](https://github.com/nla/nla-blacklight/commit/b33ec014368f72024b5caac844a26ad4953442a1))
* use author search for other authors links ([57292c7](https://github.com/nla/nla-blacklight/commit/57292c72fdaccc6b08acc42cf897b02399755ba1))
* use author search for other authors links ([e996230](https://github.com/nla/nla-blacklight/commit/e996230d9aac4d141b4843ebaa7581f73de40dff))


### Bug Fixes

* BLAC-261 resize title on record page ([f26e0dd](https://github.com/nla/nla-blacklight/commit/f26e0ddd570ce34a527f36befb19d1937a3ca16f))
* BLAC-264 style citation modal ([ae6f8bb](https://github.com/nla/nla-blacklight/commit/ae6f8bb999694cdbbf364517c200a5e7f38c74a9))
* change "Log in" to "Login" ([ffd6413](https://github.com/nla/nla-blacklight/commit/ffd641308267e56f55edbe1fe12b027e70536e69))
* change "Log in" to "Login" ([b4504b3](https://github.com/nla/nla-blacklight/commit/b4504b33f0b7bd412221c4af4a73d7f90bbd174c))
* change author search to use author_search_tesim field ([cce0081](https://github.com/nla/nla-blacklight/commit/cce0081fccc6a8e5d75cba4300734abfe5924bc2))
* change author search to use author_search_tesim field ([dd77039](https://github.com/nla/nla-blacklight/commit/dd770392693e373dac84c883c0894b27f4b364b3))
* check ind2 value for printer 264 datafield ([173b76c](https://github.com/nla/nla-blacklight/commit/173b76ceea62bd2113403aed4f6b80e16e605af3))
* check ind2 value for printer 264 datafield ([e489668](https://github.com/nla/nla-blacklight/commit/e48966858f586a4b72bca1ab387cfd7ed7e6ee78))
* corrects registration link typos ([bc0a318](https://github.com/nla/nla-blacklight/commit/bc0a31883b3faad90c006b7477c610c950eca47b))
* disallow access to blacklight-test.nla.gov.au ([371be66](https://github.com/nla/nla-blacklight/commit/371be668b956184ce3393c891fb6817fd355d765))
* disallow access to blacklight-test.nla.gov.au ([a0eb849](https://github.com/nla/nla-blacklight/commit/a0eb849e35f2836181d96ca71583a23d09e95a33))
* display index/finding aid note as bulleted list ([8c1a004](https://github.com/nla/nla-blacklight/commit/8c1a00477e77ee9b1a32f1dfe4567bc96b6523a0))
* display index/finding aid note as bulleted list ([8d3b225](https://github.com/nla/nla-blacklight/commit/8d3b225b34f691ae129219ca8a03b90dd68c19ea))
* display multiple frequencies as a bulleted list ([4f295ec](https://github.com/nla/nla-blacklight/commit/4f295ec39d457d738c18bba382bca544f4b74b4e))
* display multiple frequencies as a bulleted list ([ac99b56](https://github.com/nla/nla-blacklight/commit/ac99b566e277d5c1c2d34afd3c08d1828349eeb7))
* display printer field in an unstyled list ([35c726f](https://github.com/nla/nla-blacklight/commit/35c726f4bcfa2977350874bf03099164b2c5ea45))
* display printer field in an unstyled list ([fad34a2](https://github.com/nla/nla-blacklight/commit/fad34a2622c655195ded54c34224baac0f662649))
* do not display spelling suggestions if results are returned ([dc6c6a9](https://github.com/nla/nla-blacklight/commit/dc6c6a94f6ed2ee98c87ee29e1ca2ebe19223eff))
* do not display spelling suggestions if results are returned ([6039de4](https://github.com/nla/nla-blacklight/commit/6039de44579adddb1eddbcf05ec6389b50a966b9))
* fix author search link ([7d74186](https://github.com/nla/nla-blacklight/commit/7d741863fe0e41bc0678dc02f0b555d55cb02255))
* fix author search link ([5339531](https://github.com/nla/nla-blacklight/commit/53395310d638ce2fe82a5ccdac2aaa8cc6556078))
* fix display logic for sidebar and message bar ([68b032e](https://github.com/nla/nla-blacklight/commit/68b032eca8c6674a00fe47fdf9de8fde51a65fc8))
* fix flash message when redirecting user to login ([74e639f](https://github.com/nla/nla-blacklight/commit/74e639f47b21a5302f5aa3b33797c4d877efe2f0))
* fix flash message when redirecting user to login ([222d51c](https://github.com/nla/nla-blacklight/commit/222d51c8ed5e2766e024c5d34542cb7f2ed55599))
* fix index finding aid note test ([3d904a9](https://github.com/nla/nla-blacklight/commit/3d904a977454c73a5d45ead27790d3c8ec56929e))
* fix index finding aid note test ([fd11e5a](https://github.com/nla/nla-blacklight/commit/fd11e5a23bd5b8ea320e168d18cd30b55cad15ef))
* fix message banner ([2598ebc](https://github.com/nla/nla-blacklight/commit/2598ebcb6b693c4c4804535cd301af862f03b8cc))
* fix permissions on vendor/bundle dir at deployment ([cda539c](https://github.com/nla/nla-blacklight/commit/cda539c7b29ccaef85686ae71a57e90885c7accb))
* fix permissions on vendor/bundle dir at deployment ([1cdf1ee](https://github.com/nla/nla-blacklight/commit/1cdf1ee0f7deec5a254e529ab76164fc6ade95d9))
* fix routes and navigation spec ([cfb8368](https://github.com/nla/nla-blacklight/commit/cfb83683d200e3bbaa7d7a4c5a1462a4ed7d78a4))
* fix value of VERSION ([08cd1bb](https://github.com/nla/nla-blacklight/commit/08cd1bb216626697a489dad9d4ab50a3817aacdd))
* fix value of VERSION ([c5046f6](https://github.com/nla/nla-blacklight/commit/c5046f6a3382116a52de07b089ffda487678a362))
* fix View online URL ([634e7f6](https://github.com/nla/nla-blacklight/commit/634e7f69ac1f53134df46a318089335425411c79))
* fixes Author display value and links to search ([2447f11](https://github.com/nla/nla-blacklight/commit/2447f1131cf0f5e1ab74b74208b6e15af854bce8))
* fixes Author display value and links to search ([46314ef](https://github.com/nla/nla-blacklight/commit/46314ef6b1f20e17aaf1c08abfef1a9cfcf9c651))
* fixes Rubocop issues ([d1d1a4f](https://github.com/nla/nla-blacklight/commit/d1d1a4f740ea4da3d8953a2597934a47c8173c32))
* fixes Rubocop issues ([13ed1ad](https://github.com/nla/nla-blacklight/commit/13ed1ade487e38d44017101a45a29686f7190358))
* guard against inability to link to collection parent record ([d7c5bcd](https://github.com/nla/nla-blacklight/commit/d7c5bcd0d096ffc852e4249323ea22a4ad0b31b0))
* guard against inability to link to collection parent record ([ee8b72b](https://github.com/nla/nla-blacklight/commit/ee8b72bdd2b9dee919bba5cf9ebb1e5535599216))
* hide the search bar on the catalog index page ([d6484e4](https://github.com/nla/nla-blacklight/commit/d6484e47443028568984a631b8de513561e1e2e5))
* hide the search bar on the catalog index page ([e8f0eaa](https://github.com/nla/nla-blacklight/commit/e8f0eaac40c7b86b35dc7a1cbc13f61cda529d13))
* ignores Rubocop warnings for Blacklight helper ([2a09d90](https://github.com/nla/nla-blacklight/commit/2a09d9012ed35b86a614d0982c924121da235781))
* Make bento headings sticky ([6e70445](https://github.com/nla/nla-blacklight/commit/6e70445bd165c7ee32e1b48a2480c4364608ac37))
* prevent crash when copyright info not returned from service ([0a21e26](https://github.com/nla/nla-blacklight/commit/0a21e26becaf82f471bb0cda49ebad7ae5413c5e))
* prevent crash when copyright info not returned from service ([f9ea3fd](https://github.com/nla/nla-blacklight/commit/f9ea3fdbc21f0afb1fdc29cf730d6a370ce2432d))
* reconfigure Author field for search results also ([3591ef8](https://github.com/nla/nla-blacklight/commit/3591ef8674a52bc4958cc2dd4807a28d8f2da533))
* reconfigure Author field for search results also ([161ef7e](https://github.com/nla/nla-blacklight/commit/161ef7e95ee00b2839f4584c1c8ee1d6ebed5961))
* remove facet sidebar from catalogue search index ([02c1322](https://github.com/nla/nla-blacklight/commit/02c1322634ba699bdbdf6c0f43ea95389a7e50d7))
* remove links from former/later title and has supplement/to ([df06324](https://github.com/nla/nla-blacklight/commit/df06324d7f558366c184265a6eddfb2d7c136734))
* remove links from former/later title and has supplement/to ([6f298c9](https://github.com/nla/nla-blacklight/commit/6f298c9a6b7e5efd0d06b9e0d5f22918c534bb3e))
* restore hidden field removed from advanced search page ([be56871](https://github.com/nla/nla-blacklight/commit/be56871fde9d35e99c1a2e7cbb71fd60769cad16))
* restore hidden field removed from advanced search page ([ca991fc](https://github.com/nla/nla-blacklight/commit/ca991fcce5610faeef1c949315bbeb93d737bcd7))
* reverse subnet match condition ([7095674](https://github.com/nla/nla-blacklight/commit/7095674b57da55a30b5bfea8f340730ce0eaa99e))
* Style button actions ([7e929f4](https://github.com/nla/nla-blacklight/commit/7e929f49f96054320986d28a6dd2780d7199c776))
* update GLOBAL_MESSAGE_URL placeholder ([eb0adcb](https://github.com/nla/nla-blacklight/commit/eb0adcb516ccc6b1762eb9709bd95d1f2b488961))
* Update homepage cultural text ([460197c](https://github.com/nla/nla-blacklight/commit/460197c08ef89d313ca9a181389f04ea85d91131))
* use "author_search_tsim" as the author search field ([c39c6c8](https://github.com/nla/nla-blacklight/commit/c39c6c8824cc105da1120c16e680b6f1a1f50cb4))
* use "author_search_tsim" as the author search field ([bc3ac74](https://github.com/nla/nla-blacklight/commit/bc3ac74fd89572713bc90a39ae75a4a734ac7786))
* use SVG icon ([a5b3e7a](https://github.com/nla/nla-blacklight/commit/a5b3e7af7708417ab01e9c1c9463293357c8a58c))


### Styles

* adds icons ([8a32df2](https://github.com/nla/nla-blacklight/commit/8a32df210afe560dcc8e1e14645b2db1c6ecda13))
* adds icons ([62af15b](https://github.com/nla/nla-blacklight/commit/62af15bc649a68ff45360b8991b7679584c2eae8))
* fixes Rubocop offenses ([170bf31](https://github.com/nla/nla-blacklight/commit/170bf313b52c70dd7f5b99edbef7e1881c0fa810))
* fixes Rubocop offenses ([47f0908](https://github.com/nla/nla-blacklight/commit/47f09088c6f8ed0b2409a8799af6bbece45d77e2))


### Build System

* attempt to keep ruby-build updated via nla-deploy script ([591d33e](https://github.com/nla/nla-blacklight/commit/591d33e3ccd8be48fae136a900df6bd5f9e2bb12))
* attempt to keep ruby-build updated via nla-deploy script ([9bd5b16](https://github.com/nla/nla-blacklight/commit/9bd5b16f131b430788d854581c947472ff149602))
* **deps-dev:** bump debug from 1.6.3 to 1.7.0 ([fce550f](https://github.com/nla/nla-blacklight/commit/fce550fb6158dada470bdbd39aa8285893c355d8))
* **deps-dev:** bump debug from 1.6.3 to 1.7.0 ([e16f66c](https://github.com/nla/nla-blacklight/commit/e16f66cc32488f772fc5cf94c8a438e87fa26540))
* **deps-dev:** bump debug from 1.7.0 to 1.7.1 ([7b18449](https://github.com/nla/nla-blacklight/commit/7b18449d4770c7e3468914ba9e69188c6064d969))
* **deps-dev:** bump debug from 1.7.0 to 1.7.1 ([d108537](https://github.com/nla/nla-blacklight/commit/d108537ffc01875555a16c91e7729c0f7378ee24))
* **deps-dev:** bump faker from 3.0.0 to 3.1.0 ([7395297](https://github.com/nla/nla-blacklight/commit/7395297c12d92a08d23353d369667990c76f1102))
* **deps-dev:** bump faker from 3.0.0 to 3.1.0 ([6106f0b](https://github.com/nla/nla-blacklight/commit/6106f0b56f9b8061bc2a29c5c4308188f7e902db))
* **deps-dev:** bump selenium-webdriver from 4.6.1 to 4.7.1 ([fbba392](https://github.com/nla/nla-blacklight/commit/fbba392b26f1d68812e68bdbe65b63cbd23e378b))
* **deps-dev:** bump selenium-webdriver from 4.6.1 to 4.7.1 ([f18aa6b](https://github.com/nla/nla-blacklight/commit/f18aa6b11ce81da16eb3fa993b8682ea02eb3415))
* **deps-dev:** bump shoulda-matchers from 5.2.0 to 5.3.0 ([01b0344](https://github.com/nla/nla-blacklight/commit/01b0344fb2379399852f14f08440bb727e999d1c))
* **deps-dev:** bump shoulda-matchers from 5.2.0 to 5.3.0 ([3c91b6b](https://github.com/nla/nla-blacklight/commit/3c91b6b3d7aa066dcb78963860bc35a77bc31856))
* **deps-dev:** bump simplecov from 0.21.2 to 0.22.0 ([9d083de](https://github.com/nla/nla-blacklight/commit/9d083de5520e204e5e860123fa165d4355ae5802))
* **deps-dev:** bump simplecov from 0.21.2 to 0.22.0 ([9fd1387](https://github.com/nla/nla-blacklight/commit/9fd13870b5af9429c2206c03e48b504d0141e1d5))
* **deps-dev:** bump standard from 1.18.1 to 1.19.0 ([180239e](https://github.com/nla/nla-blacklight/commit/180239e2a90b3ab300af72fbe76e84108a9929c4))
* **deps-dev:** bump standard from 1.18.1 to 1.19.0 ([75f7d2a](https://github.com/nla/nla-blacklight/commit/75f7d2a12609ec55607cd4229f4daa2158bbe67a))
* **deps:** bump loofah from 2.19.0 to 2.19.1 ([22579a1](https://github.com/nla/nla-blacklight/commit/22579a1cffff0d6a13b1ff0b00a300664218b4c5))
* **deps:** bump loofah from 2.19.0 to 2.19.1 ([a37d198](https://github.com/nla/nla-blacklight/commit/a37d198e899db8d41c7398776d0e2d20833ba888))
* **deps:** bump puma from 6.0.0 to 6.0.2 ([328fc2f](https://github.com/nla/nla-blacklight/commit/328fc2f1b2f581a08290062d2eb758e7a7f9e9a2))
* **deps:** bump puma from 6.0.0 to 6.0.2 ([eccea63](https://github.com/nla/nla-blacklight/commit/eccea6399a8594ecd846dccdb89771424e8a24a3))
* **deps:** bump ruby/setup-ruby from 1.123.0 to 1.126.0 ([68709ad](https://github.com/nla/nla-blacklight/commit/68709adad0d93e2f3553eda68f987ac9494c6fa2))
* **deps:** bump ruby/setup-ruby from 1.123.0 to 1.126.0 ([7a66d28](https://github.com/nla/nla-blacklight/commit/7a66d283b72a4c6e3ac8240d097708ca5b09fd47))
* **deps:** bump stimulus-rails from 1.1.1 to 1.2.1 ([722fb2d](https://github.com/nla/nla-blacklight/commit/722fb2d67b458e83305fcc3cc67d42181e680112))
* **deps:** bump stimulus-rails from 1.1.1 to 1.2.1 ([1efa9ad](https://github.com/nla/nla-blacklight/commit/1efa9ada9f40b2267da0e449ce9aaf37340656a8))
* **deps:** bump view_component from 2.74.0 to 2.78.0 ([64e55cf](https://github.com/nla/nla-blacklight/commit/64e55cf13ca0eb8e3e4bc5bcc5d39b99c8400e0f))
* **deps:** bump view_component from 2.74.0 to 2.78.0 ([68b7964](https://github.com/nla/nla-blacklight/commit/68b79640d1dd051babd660c3a4bd97ab078796be))
* **deps:** bump view_component from 2.78.0 to 2.80.0 ([3016e17](https://github.com/nla/nla-blacklight/commit/3016e1760f4fbe4f459fea264d076edeeda5e00e))
* **deps:** bump view_component from 2.78.0 to 2.80.0 ([174e1eb](https://github.com/nla/nla-blacklight/commit/174e1eb0b37ac6501d91ea5d1326ff84b10780b9))
* **deps:** bump view_component from 2.80.0 to 2.82.0 ([7da5251](https://github.com/nla/nla-blacklight/commit/7da5251db21243448779442d4010f9a10b1bed2f))
* **deps:** bump view_component from 2.80.0 to 2.82.0 ([7282288](https://github.com/nla/nla-blacklight/commit/7282288b5bf3f2e96d3ab44da9a4bc79d52cefee))
* **deps:** update rails-html-sanitizer and other deps ([25f3592](https://github.com/nla/nla-blacklight/commit/25f359212fcc88a6018754500f142253750e32f8))
* **deps:** update rails-html-sanitizer and other deps ([ed8ebc6](https://github.com/nla/nla-blacklight/commit/ed8ebc6eed6eab203a267428df1a40e55a8754ae))
* fix Gemfile.lock ([4b724f7](https://github.com/nla/nla-blacklight/commit/4b724f7fb83022dc57d843432ca51337a114b843))
* fix Gemfile.lock ([2d0cd33](https://github.com/nla/nla-blacklight/commit/2d0cd33e4c33134fd31b7ca457da57c5b92935f4))
* make sure `main` branch is using a released `catalogue-patrons` version ([ab9c1d9](https://github.com/nla/nla-blacklight/commit/ab9c1d9e84b31b6362cc10ad938f46c7066cece0))
* make sure `main` branch is using a released `catalogue-patrons` version ([510f9af](https://github.com/nla/nla-blacklight/commit/510f9af4d7a9aa7db7697c941d6a54bcb8683b97))
* update dependency revisions in Gemfile for 3.2.0 Ruby upgrade ([048c1f8](https://github.com/nla/nla-blacklight/commit/048c1f8b3f4783358a1742d3242f1f6afc5dbf12))
* update dependency revisions in Gemfile for 3.2.0 Ruby upgrade ([cffa006](https://github.com/nla/nla-blacklight/commit/cffa0066814e56643c09c8376d301dc6934644af))
* update Nokogiri ([69ff8f5](https://github.com/nla/nla-blacklight/commit/69ff8f5d0dc7f04af5937dbc6376c4497a689805))
* update Nokogiri ([0b77502](https://github.com/nla/nla-blacklight/commit/0b7750289795e5a775ae5bf0dba66fcf557c1eca))
* upgrade Ruby to 3.1.3 ([8ab6b7d](https://github.com/nla/nla-blacklight/commit/8ab6b7da630d7a61901df4aa3df277c3d8003cfd))
* upgrade Ruby to 3.1.3 ([226576e](https://github.com/nla/nla-blacklight/commit/226576eb3d3999846e53d120846f8a31147991f7))


### Continuous Integration

* adds PATRONS_DB_URL env variable to verify workflow ([8c61e0e](https://github.com/nla/nla-blacklight/commit/8c61e0e2ca109de2a2e6f6e3c9edd8de6e064b10))
* adds PATRONS_DB_URL env variable to verify workflow ([ab09950](https://github.com/nla/nla-blacklight/commit/ab0995087d5d077cc06ccb64e989a9bd9a7accdc))
* adds release workflow ([14e6568](https://github.com/nla/nla-blacklight/commit/14e65683436fecf254ac76d67735f618d280a39b))
* adds release workflow ([9fbc785](https://github.com/nla/nla-blacklight/commit/9fbc78596aacef008e11dcbbc96b5feb6e696b03))
* change bundler audit and brakeman check in workflow ([32971c2](https://github.com/nla/nla-blacklight/commit/32971c2b57750ba32b608238f07d2f27f36f2f2c))
* change bundler audit and brakeman check in workflow ([5e64a1f](https://github.com/nla/nla-blacklight/commit/5e64a1f32f17ad9afe0d440f47106fde0e573f87))
* change package name in release workflow ([b900127](https://github.com/nla/nla-blacklight/commit/b9001279565211ca891bf89c9d680435bcb5ffeb))
* change package name in release workflow ([338007e](https://github.com/nla/nla-blacklight/commit/338007e38c9e447e7b8af4ffe04712a2a5f7f7cf))
* remove cucumber tests from verify workflow ([5669a46](https://github.com/nla/nla-blacklight/commit/5669a4629cff3296d496c81f45f5237c859dd447))
* remove cucumber tests from verify workflow ([b4769d3](https://github.com/nla/nla-blacklight/commit/b4769d3fec1388a02ddfc4a017b67e2eec8a1054))
* updates verify workflow ([facf328](https://github.com/nla/nla-blacklight/commit/facf3289adcc7276c1ff649aef50a942cc358070))
* updates verify workflow ([b57ce28](https://github.com/nla/nla-blacklight/commit/b57ce2830bdda5a00506a3fbc3f32cc382e204bf))


### Documentation

* additional comments in Gemfile ([295251e](https://github.com/nla/nla-blacklight/commit/295251e192ad0ff942abb4db4d49ddc91939cc6e))
* additional comments in Gemfile ([9d326a6](https://github.com/nla/nla-blacklight/commit/9d326a64ce1b8d77e0c4715358ad5b2409c692d5))
* update build status badge for "main" branch in README.md ([aaa484c](https://github.com/nla/nla-blacklight/commit/aaa484c3c3a19163ae30f6ea2ec6d63ee4f234ef))
* update build status badge for "main" branch in README.md ([f5ed708](https://github.com/nla/nla-blacklight/commit/f5ed70868cd3e44bef5b7a446d35c24e905cd4b3))
* update README.md ([d963b8e](https://github.com/nla/nla-blacklight/commit/d963b8ee2cbf7e7eb166deb5e77a1ee566e8cf56))
* update README.md ([4801fc2](https://github.com/nla/nla-blacklight/commit/4801fc241dfdc6dd9d5b2b2518b40bc9f87be06f))
* update README.md ([78088dd](https://github.com/nla/nla-blacklight/commit/78088ddd2e3a968ed88839225631c3956bbe1a64))
* update README.md ([0771ae4](https://github.com/nla/nla-blacklight/commit/0771ae4d6798c8d697816882aaefcec35d9f2c16))
* update Ruby and Bundler versions in README.md ([3a7f896](https://github.com/nla/nla-blacklight/commit/3a7f8965ad017907fcd55facad8e014166720e08))
* update Ruby and Bundler versions in README.md ([6668d3f](https://github.com/nla/nla-blacklight/commit/6668d3fe7f871b6747beb621b697b1b1349d0b23))
* updates README.md ([b6496cf](https://github.com/nla/nla-blacklight/commit/b6496cfb5799cd309b787daefe6001fbf776fac9))
* updates README.md ([aec3152](https://github.com/nla/nla-blacklight/commit/aec31528536658e6b66d58f05ff1dedb31296fb1))


### Tests

* add helper specs for bento search ([ba1d11c](https://github.com/nla/nla-blacklight/commit/ba1d11ce3608ff3152c38ef003dd097ceb5efa38))
* add helper specs for bento search ([229e5d8](https://github.com/nla/nla-blacklight/commit/229e5d81bcdb86833f3258051fe8bf59bb54e26f))
* add test for removal of advanced search sort ([fd2d092](https://github.com/nla/nla-blacklight/commit/fd2d092e3d7b03c5728880f9ef9e16560e66174f))
* add test for removal of advanced search sort ([c43adee](https://github.com/nla/nla-blacklight/commit/c43adeec7afecefa8b800bb7f525b83c44e0da27))
* adds controller test for bento search ([ff4ac85](https://github.com/nla/nla-blacklight/commit/ff4ac856f8d518b4500e57062be73a85c9246aa3))
* adds controller test for bento search ([084ffcc](https://github.com/nla/nla-blacklight/commit/084ffcc8e9806a2b546d2432226b3bea04271296))
* adds helper tests ([885dee6](https://github.com/nla/nla-blacklight/commit/885dee63b3bea58ff94a69db8a5a1a63d290ce33))
* adds helper tests ([36f9763](https://github.com/nla/nla-blacklight/commit/36f9763ad8a2a6b528dd236e1125a80b3a94c756))
* adds request and model specs ([1f04f22](https://github.com/nla/nla-blacklight/commit/1f04f22d00ba448a040d70237900e5cb8f4fff8b))
* adds request and model specs ([ba30475](https://github.com/nla/nla-blacklight/commit/ba304757ff884af5676a6572ad604ee51036f969))
* fix test ([49a8fed](https://github.com/nla/nla-blacklight/commit/49a8fedfdd864141fc8d997b8c435b5552949b0a))
* fix test ([68955c9](https://github.com/nla/nla-blacklight/commit/68955c90cb7440d5cc424d18653ab135683f8f96))
* generate brakeman.ignore config ([74be5e8](https://github.com/nla/nla-blacklight/commit/74be5e869ca49eb4407b1e725868625102efaabd))
* generate brakeman.ignore config ([745fd10](https://github.com/nla/nla-blacklight/commit/745fd10a7c16fd2fb74608d7dd2bfa4d8da94710))
* refactor cucumber tests as rspec tests ([e25b80e](https://github.com/nla/nla-blacklight/commit/e25b80e0c94ebc264270f762cfd98f218892a9b7))
* refactor cucumber tests as rspec tests ([72ee1b0](https://github.com/nla/nla-blacklight/commit/72ee1b01f84b51684f7216f146f7d06050567a45))
* update NlaThumbnailPresenter spec ([5065afb](https://github.com/nla/nla-blacklight/commit/5065afb7627c9e8e194646ed44a9167cf2929761))
* update NlaThumbnailPresenter spec ([2209ff9](https://github.com/nla/nla-blacklight/commit/2209ff96b84faf23ee92926d50d419661ad42fce))


### Code Refactoring

* also cache EDS bento search results in staging env ([a1d4d16](https://github.com/nla/nla-blacklight/commit/a1d4d161cff0e1fd0a37f2c0473a6b11566c009a))
* clean up thumbnail component template and add tests ([be3d4b7](https://github.com/nla/nla-blacklight/commit/be3d4b72a62a236f0114dcbce91c8e50cea67591))
* clean up thumbnail component template and add tests ([1ba83aa](https://github.com/nla/nla-blacklight/commit/1ba83aa62a492379c4a688844626f91fc4ba4b10))
* don't cache EDS requests in non-prod env ([1d28edf](https://github.com/nla/nla-blacklight/commit/1d28edf05fabc684a27112bcdf871fd1a56081a0))
* integrate routing changes from catalogue-patrons ([c823cc2](https://github.com/nla/nla-blacklight/commit/c823cc2b0b3c7f41cec93eeaedf682b2b842f520))
* move subnet config to environment variables ([1ba4e79](https://github.com/nla/nla-blacklight/commit/1ba4e7977e96e8be91c5187d67fe325c4a5bb97f))
* move subnet config to environment variables ([add90d4](https://github.com/nla/nla-blacklight/commit/add90d45c666b83a7e96bd45c83b8c0da7020801))
* move VERSION constant to application config file ([fea56c2](https://github.com/nla/nla-blacklight/commit/fea56c2bf5fcaa85d68f85c7bd0bfe1cfd2c1bdd))
* move VERSION constant to application config file ([0825d08](https://github.com/nla/nla-blacklight/commit/0825d0816966f234eee430cad33b68b3a561bc1c))
* reconfigure user-agent used for HTTP requests ([d5a86e8](https://github.com/nla/nla-blacklight/commit/d5a86e884bead08ba803b71b2e058d593cb85f6f))
* reconfigure user-agent used for HTTP requests ([c0bc9bc](https://github.com/nla/nla-blacklight/commit/c0bc9bc98a16d78a4a9042bbaa972fa8dd3fe241))
* refactor overridden Blacklight helper methods ([0d932c0](https://github.com/nla/nla-blacklight/commit/0d932c0086f38aad9bea7b967d906be238fdf1d3))
* remove user location and type logic ([5523df7](https://github.com/nla/nla-blacklight/commit/5523df786c64a613ad03a68663737447af71e761))
* rename RequestActionsComponent to CatalogueRequestActionsComponent ([0c6731b](https://github.com/nla/nla-blacklight/commit/0c6731b045695e2aa95da24e3a91cccc70e22374))
* set default User-Agent for Faraday requests ([686bd55](https://github.com/nla/nla-blacklight/commit/686bd554ea85969f506f7c809a64a08e89ae4a0f))
* set default User-Agent for Faraday requests ([0d3681e](https://github.com/nla/nla-blacklight/commit/0d3681e91d9a786462b23fa04123aaf55825ccee))


### Miscellaneous

* adjust version ([cfeab7b](https://github.com/nla/nla-blacklight/commit/cfeab7b136c5981d051caa5a1943da496172ae06))
* adjust version ([bd6468f](https://github.com/nla/nla-blacklight/commit/bd6468f11ac2144f4d5051e3728121c61345e66a))
* **deps:** bump hiredis-client from 0.13.0 to 0.14.0 ([0303589](https://github.com/nla/nla-blacklight/commit/03035890aff0e3411d58f7ca41564ea1ab0cb6bc))
* **deps:** update dependencies via "bundle update" ([7433407](https://github.com/nla/nla-blacklight/commit/743340755a049871791ccd24761cd5e2c76ec2e8))
* **deps:** update dependencies via "bundle update" ([4c8c692](https://github.com/nla/nla-blacklight/commit/4c8c6927cf64590e5fd42213865c0047dc3aa2bd))
* **deps:** use latest blacklight-solrcloud-repository while unreleased ([b0e0024](https://github.com/nla/nla-blacklight/commit/b0e0024c371f2397ba7dc391c1b64c4a302e47b7))
* **deps:** use latest blacklight-solrcloud-repository while unreleased ([e350a07](https://github.com/nla/nla-blacklight/commit/e350a07e445b89e50558aad766957f7493d300d8))
* fix formatting and upgrade dependencies ([d4cfd3c](https://github.com/nla/nla-blacklight/commit/d4cfd3c2fedeaa5b63292e630e5bbefc752119b5))
* fix formatting and upgrade dependencies ([1dd43e1](https://github.com/nla/nla-blacklight/commit/1dd43e13f9293f4462d9a1404c0436cbaf4e1cda))
* fix formatting issue ([6ab4035](https://github.com/nla/nla-blacklight/commit/6ab403528215d57af7a1d716034ab89ce0e443d2))
* fix release versioning ([d8a59be](https://github.com/nla/nla-blacklight/commit/d8a59be2e604be98651a2dc432e7beaaa305fc04))
* fix release versioning ([43d4a94](https://github.com/nla/nla-blacklight/commit/43d4a949622d2c92ae2ba8399fb399d9da2b0d59))
* integrate login error messages in catalogue-patrons ([ad40273](https://github.com/nla/nla-blacklight/commit/ad4027355aab71ffefc94f44f8e2d71d44460903))
* put explore sidebar widget behind feature flag ([9583290](https://github.com/nla/nla-blacklight/commit/95832906b79d8a670906a0eb5b0ee6569460bbaf))
* puts login link behind authentication ([2819114](https://github.com/nla/nla-blacklight/commit/28191148c5ffb3dda9ca46c5928dd07bb8e852ae))
* release public beta code ([39cd867](https://github.com/nla/nla-blacklight/commit/39cd867e3060b9802a77410bfd6ecd66329cf786))
* remove cucumber config and dependency ([84afc15](https://github.com/nla/nla-blacklight/commit/84afc15bb7faa422bd5be52e7bbdf32aab163ace))
* remove cucumber config and dependency ([3432fb5](https://github.com/nla/nla-blacklight/commit/3432fb55555d7681f330bfccc8368b3a9ce54a3b))
* remove unneccessary controller override ([1d02899](https://github.com/nla/nla-blacklight/commit/1d02899858f832e360c53389aa896975d4d9f864))
* remove unneccessary controller override ([0638bc2](https://github.com/nla/nla-blacklight/commit/0638bc20d7241090fc5b32dfc129c1567b7c4d48))
* sync with main branch ([d00aeca](https://github.com/nla/nla-blacklight/commit/d00aeca253fe64f22e24d18d932f0d5094a178ee))
* turn off dev caching in nla-deploy.sh ([9426495](https://github.com/nla/nla-blacklight/commit/9426495f3f888dbf0d61305002b20dc22486bd7c))
* turn off dev caching in nla-deploy.sh ([74926eb](https://github.com/nla/nla-blacklight/commit/74926eb5404463491c4f579c85dff33fa1e98c67))
* update bundler in Gemfile.lock ([435f2e8](https://github.com/nla/nla-blacklight/commit/435f2e83ff0bac416ddd72c93e2042a1df305e66))
* update dependencies ([2f4cfae](https://github.com/nla/nla-blacklight/commit/2f4cfaecdf02afbe04ef84652cfdecfd9429c556))
* update dependencies ([c20b9f3](https://github.com/nla/nla-blacklight/commit/c20b9f38e60764bc65737c2bf842851e61ec7fb8))
* update dependencies ([a5e06f3](https://github.com/nla/nla-blacklight/commit/a5e06f3cf3af7224dc6f81e733c4bfb119f3064c))
* update dependencies ([a1968dd](https://github.com/nla/nla-blacklight/commit/a1968dd9f8fd3e4858be109f0e7b06d4445d5640))
* update dependencies ([40ec9aa](https://github.com/nla/nla-blacklight/commit/40ec9aa170e724d7e9dea16458e018f036e9a4ba))
* update dependencies ([5f711aa](https://github.com/nla/nla-blacklight/commit/5f711aa68861c30bd1b886fb85b554453b7d8024))
* update dependencies ([7241cd2](https://github.com/nla/nla-blacklight/commit/7241cd2e2ee22c9ca5314b13307f60e310f63569))
* update dependency on catalogue-patrons ([0673b81](https://github.com/nla/nla-blacklight/commit/0673b8186be5802dc0f9d97684789785a96d9a13))
* update dependency on catalogue-patrons ([dc7b643](https://github.com/nla/nla-blacklight/commit/dc7b64356d17bb177021d7fed551129d7289a90d))
* update flipper ([7702962](https://github.com/nla/nla-blacklight/commit/7702962871e8da12e9ac9769376c059387e6d00f))
* upgrade dependencies ([166bbd1](https://github.com/nla/nla-blacklight/commit/166bbd1f933cb65cce8a0a46ea845aa492efe2e1))
* upgrade dependencies ([c6f9e1b](https://github.com/nla/nla-blacklight/commit/c6f9e1b016c0ff49d0afc9b963acdef7e7d2619a))
* upgrade Ruby and dependencies ([deec129](https://github.com/nla/nla-blacklight/commit/deec12914224126e4dd787f8fa12e5a8d068fa4a))
* upgrade Ruby and dependencies ([6415b77](https://github.com/nla/nla-blacklight/commit/6415b778f028df4844deda304221ef854361413b))
* upgrade to Ruby 3.2.0 ([e875363](https://github.com/nla/nla-blacklight/commit/e8753632e458cbcf645fd30d6557d76ef1802875))
* upgrade to Ruby 3.2.0 ([4b4ff3d](https://github.com/nla/nla-blacklight/commit/4b4ff3d822e753017ae56e1c3e935a21730f4bc7))
* upgrade URI gem to address CVE-2023-28755 ([7ae1729](https://github.com/nla/nla-blacklight/commit/7ae172956ad088fe006dd78aec0141cd0d81461d))
* upgrade URI gem to address CVE-2023-28755 ([855fea6](https://github.com/nla/nla-blacklight/commit/855fea663c2ac676acbea17825178fa5a3e1c6ea))
* upgrades "mock_redis" ([194375c](https://github.com/nla/nla-blacklight/commit/194375cfd8dcac1f48b243144065b66b6e9d05c5))
* upgrades "mock_redis" ([484fa35](https://github.com/nla/nla-blacklight/commit/484fa35a2c3ed3a95e18b3ac6c1b97368c7b78fc))
