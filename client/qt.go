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
	mainWindow *qml.Window
}

// XXX This can be separate types for each type of message..
type guiMessage struct {
	ContactName string

	// InboxMessage
	ReceivedTime int64
	Read         bool
	Acked        bool
	Retained     bool

	// queuedMessage
	CreatedTime int64
	AckedTime   int64

	// Message
	SentTime  int64
	EraseTime int64
	Body      string
}

func (c *qtClient) NewGuiInboxMessage(msg *InboxMessage) *guiMessage {
	var sentTime, eraseTime time.Time
	_, _, body := msg.Strings()
	isPending := msg.message == nil

	if !isPending {
		sentTime = time.Unix(*msg.message.Time, 0)
		eraseTime = msg.receivedTime.Add(messageLifetime)
	}

	re := &guiMessage{
		ContactName:  c.ContactName(msg.from),
		ReceivedTime: msg.receivedTime.UnixNano() / 1000000,
		Read:         msg.read,
		Acked:        msg.acked,
		Retained:     msg.retained,

		SentTime:  sentTime.UnixNano() / 1000000,
		EraseTime: eraseTime.UnixNano() / 1000000,
		Body:      body,
	}
	return re
}

func (c *qtClient) NewGuiOutboxMessage(msg *queuedMessage) *guiMessage {
	re := &guiMessage{
		ContactName: c.ContactName(msg.to),
		CreatedTime: msg.created.UnixNano() / 1000000,
		AckedTime:   msg.sent.UnixNano() / 1000000,
		SentTime:    msg.sent.UnixNano() / 1000000,
		EraseTime:   msg.created.Add(messageLifetime).UnixNano() / 1000000,
		Body:        string(msg.message.Body),
	}
	return re
}

func (c *qtClient) NewGuiDraftMessage(msg *Draft) *guiMessage {
	re := &guiMessage{
		ContactName: c.ContactName(msg.to),
		CreatedTime: msg.created.UnixNano() / 1000000,
		Body:        string(msg.body),
	}
	return re
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

type keyPromptAction struct {
	client    *qtClient
	stateFile *disk.StateFile
	report    chan error
}

// Returns -1 on error, 0 on bad password, 1 on success
func (action *keyPromptAction) TryPassword(password string) int {
	err := action.client.loadState(action.stateFile, password)
	if err == disk.BadPasswordError {
		// Don't report error; try again
		return 0
	} else if err == nil {
		// Success
		action.report <- err
		return 1
	} else {
		// Error
		action.report <- err
		return -1
	}
}

func (c *qtClient) keyPromptUI(stateFile *disk.StateFile) error {
	action := &keyPromptAction{
		client:    c,
		stateFile: stateFile,
		report:    make(chan error),
	}

	qml.Lock()
	c.mainWindow.Call("showKeyPrompt", action)
	c.mainWindow.Show()
	qml.Unlock()

	err := <-action.report
	return err
}

func (c *qtClient) processFetch(msg *InboxMessage) {
	qml.Lock()
	defer qml.Unlock()

	inboxMessages := c.mainWindow.ObjectByName("inboxMessages")
	inboxMessages.Call("insertObject", 0, c.NewGuiInboxMessage(msg))
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
	qml.Lock()
	inboxMessages := c.mainWindow.ObjectByName("inboxMessages")
	for _, msg := range c.inbox {
		inboxMessages.Call("appendObject", c.NewGuiInboxMessage(msg))
	}

	outboxMessages := c.mainWindow.ObjectByName("outboxMessages")
	for _, msg := range c.outbox {
		outboxMessages.Call("appendObject", c.NewGuiOutboxMessage(msg))
	}

	draftMessages := c.mainWindow.ObjectByName("draftMessages")
	for _, msg := range c.drafts {
		draftMessages.Call("appendObject", c.NewGuiDraftMessage(msg))
	}

	c.mainWindow.Set("finishedLoading", true)
	c.mainWindow.Show()
	qml.Unlock()

	for {
		select {
		case sigReq := <-c.signingRequestChan:
			c.processSigningRequest(sigReq)
		case newMessage := <-c.newMessageChan:
			c.processNewMessage(newMessage)
		case msr := <-c.messageSentChan:
			if msr.id != 0 {
				c.processMessageSent(msr)
			}
		case update := <-c.pandaChan:
			c.processPANDAUpdate(update)
		case <-c.backgroundChan: // XXX ???
		case <-c.log.updateChan: // XXX ???
		case <-c.timerChan: // XXX ??? - Not used by cli
		}
	}
}

func (c *qtClient) setupWindow() error {
	engine := qml.NewEngine()
	component, err := engine.LoadFile("qml/pond.qml")
	if err != nil {
		return err
	}
	c.mainWindow = component.CreateWindow(nil)
	go c.loadUI()
	c.mainWindow.Wait()
	return nil
}

func (c *qtClient) Start() {
	if err := qml.Run(c.setupWindow); err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1) // XXX
	}
}
