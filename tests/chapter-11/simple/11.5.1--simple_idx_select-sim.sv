// Copyright (C) 2019-2021  The SymbiFlow Authors.
//
// Use of this source code is governed by a ISC-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/ISC
//
// SPDX-License-Identifier: ISC


/*
:name: simple_idx_select_sim
:description: minimal indexed select bit simulation test (without result verification)
:type: simulation elaboration parsing
:tags: 11.5.1
*/
module top(input [3:0] a, output b);

    assign b = a[2];

endmodule
