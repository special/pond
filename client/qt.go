// XXX +build !nogui

package main

import (
	"fmt"
	"io"
	"os"
	"time"

	"gopkg.in/qml.v1"

	"github.com/agl/pond/client/disk"
	"github.com/agl/pond/panda"
)

const haveQt = true

type qtClient struct {
	client
}

func NewQtClient(stateFilename string, rand io.Reader, testing, autoFetch bool) *qtClient {
	c := &qtClient{
		client: client{
			testing:            testing,
			dev:                testing,
			autoFetch:          autoFetch,
			stateFilename:      stateFilename,
			log:                NewLog(),
			rand:               rand,
			contacts:           make(map[uint64]*Contact),
			drafts:             make(map[uint64]*Draft),
			newMessageChan:     make(chan NewMessage),
			messageSentChan:    make(chan messageSendResult, 1),
			backgroundChan:     make(chan interface{}, 8),
			pandaChan:          make(chan pandaUpdate, 1),
			usedIds:            make(map[uint64]bool),
			signingRequestChan: make(chan signingRequest),
		},
	}
	c.ui = c

	c.newMeetingPlace = func() panda.MeetingPlace {
		return &panda.HTTPMeetingPlace{
			TorAddress: c.torAddress,
			URL:        "https://panda-key-exchange.appspot.com/exchange",
		}
	}
	//	c.log.toStderr = false

	return c
}

func (c *qtClient) initUI() {
}

// loadingUI shows a basic "loading" prompt while the state file is read.
func (c *qtClient) loadingUI() {
}

// torPromptUI prompts the user to start Tor.
func (c *qtClient) torPromptUI() error {
	fmt.Println("Should show tor prompt now")
	return nil
}

// sleepUI waits the given amount of time or never returns if the user
// closes the UI.
func (c *qtClient) sleepUI(d time.Duration) error {
	return nil
}

// errorUI shows an error and returns.
func (c *qtClient) errorUI(msg string, fatal bool) {
}

// ShutdownAndSuspend quits the program - possibly waiting for the user
// to close the window in the case of a GUI so any error message can be
// read first.
func (c *qtClient) ShutdownAndSuspend() error {
	return nil
}
func (c *qtClient) createPassphraseUI() (string, error) {
	return "", nil
}
func (c *qtClient) createErasureStorage(pw string, stateFile *disk.StateFile) error {
	return nil
}

// createAccountUI allows the user to either create a new account or to
// import from a entombed statefile. It returns whether an import
// occured and an error.
func (c *qtClient) createAccountUI(stateFile *disk.StateFile, pw string) (bool, error) {
	return false, nil
}
func (c *qtClient) keyPromptUI(stateFile *disk.StateFile) error {
	return nil
}
func (c *qtClient) processFetch(msg *InboxMessage) {
}
func (c *qtClient) processServerAnnounce(announce *InboxMessage) {
}
func (c *qtClient) processAcknowledgement(ackedMsg *queuedMessage) {
}

// processRevocationOfUs is called when a revocation is received that
// revokes our group key for a contact.
func (c *qtClient) processRevocationOfUs(by *Contact) {
}

// processRevocation is called when we have finished processing a
// revocation. This includes revocations of others and of this
// ourselves. In the latter case, this is called after
// processRevocationOfUs.
func (c *qtClient) processRevocation(by *Contact) {
}

// processMessageSent is called when an outbox message has been
// delivered to the destination server.
func (c *qtClient) processMessageDelivered(msg *queuedMessage) {
}

// processPANDAUpdateUI is called on each PANDA update to update the
// UI and unseal pending messages.
func (c *qtClient) processPANDAUpdateUI(update pandaUpdate) {
}

// removeInboxMessageUI removes a message from the inbox UI.
func (c *qtClient) removeInboxMessageUI(msg *InboxMessage) {
}

// removeOutboxMessageUI removes a message from the outbox UI.
func (c *qtClient) removeOutboxMessageUI(msg *queuedMessage) {
}

// addRevocationMessageUI notifies the UI that a new revocation message
// has been created.
func (c *qtClient) addRevocationMessageUI(msg *queuedMessage) {
}

// removeContactUI removes a contact from the UI.
func (c *qtClient) removeContactUI(contact *Contact) {
}

// logEventUI is called when an exceptional event has been logged for
// the given contact.
func (c *qtClient) logEventUI(contact *Contact, event Event) {
}

// mainUI starts the main interface.
func (c *qtClient) mainUI() {
}

func (c *qtClient) setupWindow() error {
	engine := qml.NewEngine()
	component, err := engine.LoadFile("qml/pond.qml")
	if err != nil {
		return err
	}
	window := component.CreateWindow(nil)
	window.Show()
	window.Wait()
	return nil
}

func (c *qtClient) Start() {
	go c.loadUI()
	if err := qml.Run(c.setupWindow); err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1) // XXX
	}
}
