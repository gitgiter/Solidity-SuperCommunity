// Import the page's CSS. Webpack will know what to do with it.
import '../styles/app.css'

// Import libraries we need.
import { default as Web3 } from 'web3'
import { default as contract } from 'truffle-contract'

// Import our contract artifacts and turn them into usable abstractions.
import superCommunityArtifact from '../../build/contracts/SuperCommunity.json'

// SuperCommunity is our usable abstraction, which we'll use through the code below.
const SuperCommunity = contract(superCommunityArtifact)

// The following code is simple to show off interacting with your contracts.
// As your needs grow you will likely need to change its form and structure.
// For application bootstrapping, check out window.addEventListener below.
let accounts
let account

const App = {
  start: function () {
    const self = this

    // Bootstrap the SuperCommunity abstraction for Use.
    SuperCommunity.setProvider(web3.currentProvider)

    // Get the initial account balance so it can be displayed.
    web3.eth.getAccounts(function (err, accs) {
      if (err != null) {
        alert('There was an error fetching your accounts.')
        return
      }

      if (accs.length === 0) {
        alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.")
        return
      }

      accounts = accs
      account = accounts[0]
      // detect account change
      var accountInterval = setInterval(function() {
        if (web3.eth.accounts[0] !== account) {
          console.log('account change from ' + account + ' to ' + web3.eth.accounts[0])
          account = web3.eth.accounts[0];
          self.refreshForm()
        }
      }, 100);

      self.refreshForm()
      self.getAllComments()
    })
  },

  refreshForm: function () {
    // if this account register before, hide the sign up form
    var flag = false
    SuperCommunity.deployed().then(function(contractInstance) {
      return contractInstance.getNameByAddr.call(account)
    }).then(function(result) {
      console.log(result)
      if (result !== "") {
        $('.form').hide()
        flag = true
      }
    })

    if (flag) return

    $('.form').show()
    $('.form').find('input, textarea').on('keyup blur focus', function (e) {
      
      var $this = $(this),
          label = $this.prev('label');
  
        if (e.type === 'keyup') {
          if ($this.val() === '') {
              label.removeClass('active highlight');
            } else {
              label.addClass('active highlight');
            }
        } else if (e.type === 'blur') {
          if( $this.val() === '' ) {
            label.removeClass('active highlight'); 
          } else {
            label.removeClass('highlight');   
          }   
        } else if (e.type === 'focus') {
          
          if( $this.val() === '' ) {
            label.removeClass('highlight'); 
          } 
          else if( $this.val() !== '' ) {
            label.addClass('highlight');
          }
        }
    });
  },

  register: function () {
    const self = this

    const name = $('#name').val()
    // below vars are no used, just a demo
    var moto  = $("#moto").val();
    var hobby = $("#hobby").val();
    var birthday = $("#birthday").val();

    if (name == "") {
      alert("Name can not be empty");
      return;
    }

    if (name.length <= 3) {
      alert("Name should hava at least 3 characters");
      return;
    }
    
    SuperCommunity.deployed().then(function(contractInstance) {
      return contractInstance.getAddrByName.call(name)
    }).then(function(result) {
      console.log(result)
      if (result !== '0x0000000000000000000000000000000000000000') {
        alert('This name has been used.')
      }
      else {
        // register
        SuperCommunity.deployed().then(function(contractInstance) {
          return contractInstance.register(name, {from: account})
        }).then(function(result) {
          console.log(result)
          alert('Successfully registered, enjoy yourself!')
          return result
        })
        .catch(function(err) {
          err=>{console.warn(err)}
        });
      }
    })
  },

  sendComment: function() {
    var comment = $('#new-comment').val()
    var user = ''
    const self = this
    console.log(comment)
    if (comment === '') {
      alert('Comment cannot be empty.')
      return
    }
    SuperCommunity.deployed().then(function(contractInstance) {
      return contractInstance.getNameByAddr.call(account)
    }).then(function(result) {
      console.log(result)
      user = result
      if (result === '') {
        alert('Please register first.')
      }
      else {
        // send comment
        SuperCommunity.deployed().then(function(contractInstance) {
            return contractInstance.sendComment(comment, {from: account})
        }).then(function(result) {
          alert('Successfully send comment.')
          // append child
          self.append(user, comment)
          return result
        })
        .catch(function(err) {
          err=>{console.warn(err)}
        });
      }
    })
  },

  append: function(user, comment) {

    console.log($('#comments-list').children().length)
    if ($('#comments-list').children().length === 1) {
      var new_comment = '<li>\
                      <div class="comment-main-level">\
                        <!-- Avatar -->\
                        <div class="comment-avatar"><img src="http://www.zhongyi9999.com/d/file/wh/yw/2017-11-23/018fe293f585bbfe850c99e31a34843c.png" alt=""></div>\
                        <div class="comment-box">\
                          <div class="comment-head">\
                            <h6 class="comment-name by-manager">' + user + '</h6>\
                            <span>20 minutes ago</span>\
                            <i class="fa fa-envelope" ></i>\
                            <i class="fa fa-dollar" ></i>\
                            <i class="fa fa-heart" ></i>\
                          </div>\
                          <div class="comment-content">' + comment + '</div>\
                        </div>\
                      </div>\
                    </li>'
      console.log(new_comment)
      $('#comments-list').append(new_comment)
    }
    else {
      var new_comment = '<li>\
                      <div class="comment-main-level">\
                        <!-- Avatar -->\
                        <div class="comment-avatar"><img src="http://www.jf258.com/uploads/2013-07-16/033639235.jpg" alt=""></div>\
                        <div class="comment-box">\
                          <div class="comment-head">\
                            <h6 class="comment-name">' + user + '</h6>\
                            <span>20 minutes ago</span>\
                            <i class="fa fa-envelope" ></i>\
                            <i class="fa fa-dollar" ></i>\
                            <i class="fa fa-heart" ></i>\
                          </div>\
                          <div class="comment-content">' + comment + '</div>\
                        </div>\
                      </div>\
                    </li>'
      console.log(new_comment)
      $('#comments-list').append(new_comment)
    }
    // add click listener to new item
    self.manageClick()
  },

  getAllComments: function() {
    // get comments
    const self = this
    SuperCommunity.deployed().then(function(contractInstance) {
      return contractInstance.getCommentCount.call()
    }).then(function(result) {       
      var size = result['c'][0]
      console.log(size)
      for (var i = 0; i < size; i++) {
        let index = i // important
        SuperCommunity.deployed().then(function(contractInstance) {
          // console.log(index)
          return contractInstance.getCommentByIndex.call(index)
        }).then(function(result) {
          // append child
          var user = result[0]
          var comment = result[1]
          // console.log(result)
          // console.log(user)
          // console.log(comment)
          self.append(user, comment)          
          return result
        })
        .catch(function(err) {
          err=>{console.warn(err)}
        });
      }
      return result
    })
    .catch(function(err) {
      err=>{console.warn(err)}
    });
  },

  manageClick: function() {
    const self = this

    $('.fa-heart').last().click(function() {
      var user = $(this).siblings('h6').text()
      console.log('watching: ' + user)
      self.watch(user)  
    });

    $('.fa-dollar').last().click(function() {
      var index = $('.fa-dollar').index(this)
      console.log('rewarding: ' + index)
      self.rewardComment(index)  
    });

    $('.fa-envelope').last().click(function() {
      var user = $(this).siblings('h6').text()
      console.log('sending to: ' + user)
      self.sendMail(user)  
    });
  },

  watch: function(user) {
    SuperCommunity.deployed().then(function(contractInstance) {
      return contractInstance.getNameByAddr.call(account)
    }).then(function(result) {
      console.log(result)
      if (result === '') {
        alert('Please register first.')
      }
      else {
        // watch a user
        SuperCommunity.deployed().then(function(contractInstance) {
          return contractInstance.watch(user, {from: account})
        }).then(function(result) {
          console.log(result)
          alert('Successfully watch.')
          return result
        })
        .catch(function(err) {
          err=>{console.warn(err)}
        });
      }
    })
  },

  rewardComment: function(index) {
    // get amount
    var amount = prompt('How many ether would you like to reward?\n(at least 1)')
    if (Number(amount) < 1) {
      alert('You should reward at least 1 ether.')
      return
    }
    console.log('amount: ' + amount)
    SuperCommunity.deployed().then(function(contractInstance) {
      return contractInstance.getNameByAddr.call(account)
    }).then(function(result) {
      console.log(result)
      if (result === '') {
        alert('Please register first.')
      }
      else {
        // reward a comment
        SuperCommunity.deployed().then(function(contractInstance) {          
          return contractInstance.rewardComment(index, {from: account, value: web3.toWei(amount)})
        }).then(function(result) {
          console.log(result)
          alert('Successfully reward.')
          return result
        })
        .catch(function(err) {
          err=>{console.warn(err)}
        });
      }
    })
  },

  sendMail: function(user) {
    // edit mail
    var title = prompt('Edit your title below:') 
    if (Number(title) < 1) {
      alert('Your title cannot be empty.')
      return
    }
    var mail = prompt('Edit your mail below:') 
    if (Number(mail) < 1) {
      alert('Your mail cannot be empty.')
      return
    }
    SuperCommunity.deployed().then(function(contractInstance) {
      return contractInstance.getNameByAddr.call(account)
    }).then(function(result) {
      console.log(result)
      if (result === '') {
        alert('Please register first.')
      }
      else {
        // send mail to a user
        SuperCommunity.deployed().then(function(contractInstance) {
          return contractInstance.sendMail(user, title, mail, {from: account})
        }).then(function(result) {
          console.log(result)
          alert('Successfully send mail.')
          return result
        })
        .catch(function(err) {
          err=>{console.warn(err)}
        });
      }
    })
  },

  guess: function() {
    // init the game bar to 0 percent
    const self = this

    self.refreshBonus()

    $('#percent').on('change', function(){
      var val = parseInt($(this).val());
      SuperCommunity.deployed().then(function(contractInstance) {
        return contractInstance.guess(val, {from: account, value: web3.toWei(1)})
      }).then(function(result) {
        self.refreshBonus()
      })
    });
  },

  change: function (val) {
    var $circle = $('#svg #bar');
      
    if (isNaN(val)) {
      val = 0; 
    }
    else{
      var r = $circle.attr('r');
      var c = Math.PI*(r*2);
      
      if (val < 0) { val = 0;}
      if (val > 100) { val = 100;}
      
      var pct = ((100-val)/100)*c;
      
      $circle.css({ strokeDashoffset: pct});
      
      val = Math.round(val)
      $('#cont').attr('data-pct',val);
      $('#bonus').text(val + '%');
    }
  },

  refreshBonus: function() {
    // refresh the bonus
    const self = this

    SuperCommunity.deployed().then(function(contractInstance) {
      return contractInstance.getWinnerName.call()
    }).then(function(winners) {
      console.log('winners: ' + winners)
      console.log('winners length: ' + winners.length)
      SuperCommunity.deployed().then(function(contractInstance) {
        return contractInstance.getNameByAddr.call(account)
      }).then(function(name) {
        console.log('name: ' + name)
        // less or more than three winners
        var first = 0, second = 0, third = 0

        if (winners[0] === name) {
          first = 1
        }
        if (winners[1] === name) {
          second = 1
        }
        if (winners[2] === name) {
          third = 1
        }
        self.change((first*3 + second*2 + third*1) / 6 * 100)
      })
    })
  }
  
}

window.App = App

window.addEventListener('load', function () {
  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    console.warn(
      'Using web3 detected from external source.' +
      ' If you find that your accounts don\'t appear or you have 0 SuperCommunity,' +
      ' ensure you\'ve configured that source properly.' +
      ' If using MetaMask, see the following link.' +
      ' Feel free to delete this warning. :)' +
      ' http://truffleframework.com/tutorials/truffle-and-metamask'
    )
    // Use Mist/MetaMask's provider
    window.web3 = new Web3(web3.currentProvider)
  } else {
    console.warn(
      'No web3 detected. Falling back to http://127.0.0.1:9545.' +
      ' You should remove this fallback when you deploy live, as it\'s inherently insecure.' +
      ' Consider switching to Metamask for development.' +
      ' More info here: http://truffleframework.com/tutorials/truffle-and-metamask'
    )
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3 = new Web3(new Web3.providers.HttpProvider('http://127.0.0.1:9545'))
  }

  App.start()
  App.guess()
  
})
