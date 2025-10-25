(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-INVALID-PROPOSAL-TITLE u101)
(define-constant ERR-INVALID-PROPOSAL-DESCRIPTION u102)
(define-constant ERR-INVALID-BUDGET u103)
(define-constant ERR-INVALID-TIMELINE u104)
(define-constant ERR-INVALID-VOTING-PERIOD u105)
(define-constant ERR-PROPOSAL-ALREADY-EXISTS u106)
(define-constant ERR-PROPOSAL-NOT-FOUND u107)
(define-constant ERR-INVALID-TIMESTAMP u108)
(define-constant ERR-INSUFFICIENT-STAKE u109)
(define-constant ERR-ALREADY-VOTED u110)
(define-constant ERR-VOTING-CLOSED u111)
(define-constant ERR-PROPOSAL-NOT-APPROVED u112)
(define-constant ERR-INVALID-UPDATE-PARAM u113)
(define-constant ERR-MAX-PROPOSALS-EXCEEDED u114)
(define-constant ERR-INVALID-PROPOSAL-TYPE u115)
(define-constant ERR-INVALID-QUADRATIC_FACTOR u116)
(define-constant ERR-INVALID-EXECUTION_DELAY u117)
(define-constant ERR-INVALID-STATUS u118)
(define-constant ERR-INVALID-CREATOR u119)
(define-constant ERR-INVALID-VOTE_WEIGHT u120)
(define-constant ERR-TREASURY-NOT-SET u121)
(define-constant ERR-TOKEN-NOT-SET u122)
(define-constant ERR-INVALID-MIN-STAKE u123)
(define-constant ERR-INVALID-MAX-BUDGET u124)
(define-constant ERR-INVALID-MIN-VOTES u125)
(define-constant ERR-PROPOSAL-EXPIRED u126)
(define-constant ERR-NOT-MEMBER u127)
(define-constant ERR-INVALID-AMOUNT u128)
(define-constant ERR-TRANSFER-FAILED u129)
(define-constant ERR-EXECUTION-FAILED u130)

(define-data-var next-proposal-id uint u0)
(define-data-var max-proposals uint u1000)
(define-data-var min-stake-required uint u100)
(define-data-var voting-period uint u144)
(define-data-var execution-delay uint u10)
(define-data-var quadratic-factor uint u2)
(define-data-var treasury-contract (optional principal) none)
(define-data-var token-contract (optional principal) none)
(define-data-var min-votes-threshold uint u50)
(define-data-var max-budget uint u1000000)

(define-map proposals
  uint
  {
    title: (string-ascii 100),
    description: (string-utf8 500),
    budget: uint,
    timeline: uint,
    creator: principal,
    start-time: uint,
    end-time: uint,
    yes-votes: uint,
    no-votes: uint,
    status: (string-ascii 20),
    proposal-type: (string-ascii 50),
    executed: bool
  }
)

(define-map votes
  { proposal-id: uint, voter: principal }
  { vote: bool, weight: uint }
)

(define-map staked-tokens principal uint)

(define-read-only (get-proposal (id uint))
  (map-get? proposals id)
)

(define-read-only (get-vote (id uint) (voter principal))
  (map-get? votes { proposal-id: id, voter: voter })
)

(define-read-only (get-stake (user principal))
  (default-to u0 (map-get? staked-tokens user))
)

(define-private (validate-title (title (string-ascii 100)))
  (if (and (> (len title) u0) (<= (len title) u100))
      (ok true)
      (err ERR-INVALID-PROPOSAL-TITLE))
)

(define-private (validate-description (desc (string-utf8 500)))
  (if (and (> (len desc) u0) (<= (len desc) u500))
      (ok true)
      (err ERR-INVALID-PROPOSAL-DESCRIPTION))
)

(define-private (validate-budget (budget uint))
  (if (and (> budget u0) (<= budget (var-get max-budget)))
      (ok true)
      (err ERR-INVALID-BUDGET))
)

(define-private (validate-timeline (timeline uint))
  (if (> timeline u0)
      (ok true)
      (err ERR-INVALID-TIMELINE))
)

(define-private (validate-proposal-type (ptype (string-ascii 50)))
  (if (or (is-eq ptype "content-creation") (is-eq ptype "platform-upgrade") (is-eq ptype "community-event"))
      (ok true)
      (err ERR-INVALID-PROPOSAL-TYPE))
)

(define-private (validate-stake (amount uint))
  (if (>= amount (var-get min-stake-required))
      (ok true)
      (err ERR-INSUFFICIENT-STAKE))
)

(define-private (validate-voting-open (proposal-id uint))
  (let ((prop (unwrap! (get-proposal proposal-id) (err ERR-PROPOSAL-NOT-FOUND))))
    (if (and (>= block-height (get start-time prop)) (<= block-height (get end-time prop)))
        (ok true)
        (err ERR-VOTING-CLOSED)))
)

(define-private (calculate-quadratic-weight (stake uint))
  (pow stake (var-get quadratic-factor))
)

(define-private (is-member (user principal))
  (if (> (get-stake user) u0)
      (ok true)
      (err ERR-NOT-MEMBER))
)

(define-public (set-treasury-contract (contract principal))
  (begin
    (asserts! (is-eq tx-sender contract-caller) (err ERR-NOT-AUTHORIZED))
    (var-set treasury-contract (some contract))
    (ok true)
  )
)

(define-public (set-token-contract (contract principal))
  (begin
    (asserts! (is-eq tx-sender contract-caller) (err ERR-NOT-AUTHORIZED))
    (var-set token-contract (some contract))
    (ok true)
  )
)

(define-public (set-min-stake-required (new-min uint))
  (begin
    (asserts! (is-eq tx-sender contract-caller) (err ERR-NOT-AUTHORIZED))
    (asserts! (> new-min u0) (err ERR-INVALID-MIN-STAKE))
    (var-set min-stake-required new-min)
    (ok true)
  )
)

(define-public (set-voting-period (new-period uint))
  (begin
    (asserts! (is-eq tx-sender contract-caller) (err ERR-NOT-AUTHORIZED))
    (asserts! (> new-period u0) (err ERR-INVALID-VOTING-PERIOD))
    (var-set voting-period new-period)
    (ok true)
  )
)

(define-public (set-execution-delay (new-delay uint))
  (begin
    (asserts! (is-eq tx-sender contract-caller) (err ERR-NOT-AUTHORIZED))
    (asserts! (> new-delay u0) (err ERR-INVALID-EXECUTION_DELAY))
    (var-set execution-delay new-delay)
    (ok true)
  )
)

(define-public (set-quadratic-factor (new-factor uint))
  (begin
    (asserts! (is-eq tx-sender contract-caller) (err ERR-NOT-AUTHORIZED))
    (asserts! (and (> new-factor u0) (<= new-factor u5)) (err ERR-INVALID-QUADRATIC_FACTOR))
    (var-set quadratic-factor new-factor)
    (ok true)
  )
)

(define-public (set-max-budget (new-max uint))
  (begin
    (asserts! (is-eq tx-sender contract-caller) (err ERR-NOT-AUTHORIZED))
    (asserts! (> new-max u0) (err ERR-INVALID-MAX-BUDGET))
    (var-set max-budget new-max)
    (ok true)
  )
)

(define-public (set-min-votes-threshold (new-min uint))
  (begin
    (asserts! (is-eq tx-sender contract-caller) (err ERR-NOT-AUTHORIZED))
    (asserts! (> new-min u0) (err ERR-INVALID-MIN-VOTES))
    (var-set min-votes-threshold new-min)
    (ok true)
  )
)

(define-public (stake-tokens (amount uint))
  (let ((token (unwrap! (var-get token-contract) (err ERR-TOKEN-NOT-SET))))
    (try! (validate-stake amount))
    (try! (contract-call? token transfer amount tx-sender (as-contract tx-sender) none))
    (map-set staked-tokens tx-sender (+ (get-stake tx-sender) amount))
    (ok true)
  )
)

(define-public (unstake-tokens (amount uint))
  (let ((token (unwrap! (var-get token-contract) (err ERR-TOKEN-NOT-SET)))
        (current-stake (get-stake tx-sender)))
    (asserts! (>= current-stake amount) (err ERR-INSUFFICIENT-STAKE))
    (try! (as-contract (contract-call? token transfer amount tx-sender tx-sender none)))
    (map-set staked-tokens tx-sender (- current-stake amount))
    (ok true)
  )
)

(define-public (submit-proposal
  (title (string-ascii 100))
  (description (string-utf8 500))
  (budget uint)
  (timeline uint)
  (ptype (string-ascii 50))
)
  (let ((next-id (var-get next-proposal-id))
        (start block-height)
        (end (+ start (var-get voting-period))))
    (try! (is-member tx-sender))
    (asserts! (< next-id (var-get max-proposals)) (err ERR-MAX-PROPOSALS-EXCEEDED))
    (try! (validate-title title))
    (try! (validate-description description))
    (try! (validate-budget budget))
    (try! (validate-timeline timeline))
    (try! (validate-proposal-type ptype))
    (map-set proposals next-id
      {
        title: title,
        description: description,
        budget: budget,
        timeline: timeline,
        creator: tx-sender,
        start-time: start,
        end-time: end,
        yes-votes: u0,
        no-votes: u0,
        status: "active",
        proposal-type: ptype,
        executed: false
      }
    )
    (var-set next-proposal-id (+ next-id u1))
    (print { event: "proposal-submitted", id: next-id })
    (ok next-id)
  )
)

(define-public (vote-on-proposal (proposal-id uint) (vote bool))
  (let ((prop (unwrap! (get-proposal proposal-id) (err ERR-PROPOSAL-NOT-FOUND)))
        (weight (calculate-quadratic-weight (get-stake tx-sender))))
    (try! (is-member tx-sender))
    (try! (validate-voting-open proposal-id))
    (asserts! (is-none (get-vote proposal-id tx-sender)) (err ERR-ALREADY-VOTED))
    (asserts! (> weight u0) (err ERR-INVALID-VOTE_WEIGHT))
    (map-set votes { proposal-id: proposal-id, voter: tx-sender } { vote: vote, weight: weight })
    (if vote
        (map-set proposals proposal-id (merge prop { yes-votes: (+ (get yes-votes prop) weight) }))
        (map-set proposals proposal-id (merge prop { no-votes: (+ (get no-votes prop) weight) })))
    (print { event: "vote-cast", proposal-id: proposal-id, voter: tx-sender, vote: vote })
    (ok true)
  )
)

(define-public (execute-proposal (proposal-id uint))
  (let ((prop (unwrap! (get-proposal proposal-id) (err ERR-PROPOSAL-NOT-FOUND)))
        (treasury (unwrap! (var-get treasury-contract) (err ERR-TREASURY-NOT-SET)))
        (total-votes (+ (get yes-votes prop) (get no-votes prop))))
    (asserts! (> block-height (+ (get end-time prop) (var-get execution-delay))) (err ERR-PROPOSAL-EXPIRED))
    (asserts! (is-eq (get status prop) "active") (err ERR-INVALID-STATUS))
    (asserts! (not (get executed prop)) (err ERR-PROPOSAL-NOT-APPROVED))
    (asserts! (> (get yes-votes prop) (get no-votes prop)) (err ERR-PROPOSAL-NOT-APPROVED))
    (asserts! (>= total-votes (var-get min-votes-threshold)) (err ERR-INVALID-MIN-VOTES))
    (try! (as-contract (contract-call? treasury release-funds (get creator prop) (get budget prop))))
    (map-set proposals proposal-id (merge prop { status: "executed", executed: true }))
    (print { event: "proposal-executed", id: proposal-id })
    (ok true)
  )
)

(define-public (cancel-proposal (proposal-id uint))
  (let ((prop (unwrap! (get-proposal proposal-id) (err ERR-PROPOSAL-NOT-FOUND))))
    (asserts! (is-eq (get creator prop) tx-sender) (err ERR-NOT-AUTHORIZED))
    (asserts! (< block-height (get end-time prop)) (err ERR-VOTING-CLOSED))
    (map-set proposals proposal-id (merge prop { status: "cancelled", executed: false }))
    (print { event: "proposal-cancelled", id: proposal-id })
    (ok true)
  )
)

(define-read-only (get-proposal-count)
  (ok (var-get next-proposal-id))
)

(define-read-only (get-total-staked)
  (fold + (map-get? staked-tokens) u0)
)