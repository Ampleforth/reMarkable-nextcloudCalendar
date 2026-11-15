// SPDX-License-Identifier: GPL-3.0-only
package main

import "testing"

func TestWeekStartPersistsAndValidates(t *testing.T) {
	s, _ := testStore(t)
	if s.status()["week_start"] != 1 {
		t.Fatal("default should be Monday")
	}
	day := 0
	if err := s.preferences("", "", &day); err != nil {
		t.Fatal(err)
	}
	reopened, err := openStore(s.path)
	if err != nil {
		t.Fatal(err)
	}
	if reopened.status()["week_start"] != 0 {
		t.Fatal("Sunday did not persist")
	}
	if err = reopened.preferences("12h", ""); err != nil {
		t.Fatal(err)
	}
	if reopened.status()["week_start"] != 0 {
		t.Fatal("unrelated preference reset week start")
	}
	for _, invalid := range []int{-1, 7, 100} {
		if err = reopened.preferences("", "", &invalid); err == nil {
			t.Fatal("invalid weekday accepted")
		}
	}
	if reopened.status()["week_start"] != 0 {
		t.Fatal("invalid weekday changed preference")
	}
}

func TestMoveLayoutCapabilityAndPersistence(t *testing.T) {
	s, _ := testStore(t)
	s.arm64 = false
	if err := s.setMoveLayout(true); err == nil {
		t.Fatal("ARMv7 accepted Move layout")
	}
	s.arm64 = true
	if err := s.setMoveLayout(true); err != nil {
		t.Fatal(err)
	}
	reopened, err := openStore(s.path)
	if err != nil {
		t.Fatal(err)
	}
	if !reopened.state.PaperProMove {
		t.Fatal("Move preference did not persist")
	}
	s.busy = true
	if err = s.setMoveLayout(false); err == nil {
		t.Fatal("change during sync accepted")
	}
	if !s.state.PaperProMove {
		t.Fatal("failed update cleared preference")
	}
	s.busy = false
	if err = s.setMoveLayout(false); err != nil {
		t.Fatal(err)
	}
	if s.state.PaperProMove {
		t.Fatal("cannot disable Move layout")
	}
}
