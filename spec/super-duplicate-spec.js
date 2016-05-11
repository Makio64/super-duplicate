'use babel';

import SuperDuplicate from '../lib/super-duplicate';

// Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
//
// To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
// or `fdescribe`). Remove the `f` to unfocus the block.

describe('SuperDuplicate', () => {
  let workspaceElement, activationPromise;

  beforeEach(() => {
	workspaceElement = atom.views.getView(atom.workspace);
	activationPromise = atom.packages.activatePackage('super-duplicate');
  });

  describe('duplicate', () => {
	it('duplicate the lines', () => {
	  expect(workspaceElement.querySelector('.super-duplicate')).not.toExist();
	  atom.commands.dispatch(workspaceElement, 'super-duplicate:duplicate');

	  waitsForPromise(() => {
		return activationPromise;
	  });

	  runs(() => {
		expect(workspaceElement.querySelector('.super-duplicate')).toExist();

		let superDuplicateElement = workspaceElement.querySelector('.super-duplicate');
		expect(superDuplicateElement).toExist();

		let superDuplicatePanel = atom.workspace.panelForItem(superDuplicateElement);
		expect(superDuplicatePanel.isVisible()).toBe(true);
		atom.commands.dispatch(workspaceElement, 'super-duplicate:duplicate');
		expect(superDuplicatePanel.isVisible()).toBe(false);
	  });
	});

	it('hides and shows the view', () => {
	  // This test shows you an integration test testing at the view level.

	  // Attaching the workspaceElement to the DOM is required to allow the
	  // `toBeVisible()` matchers to work. Anything testing visibility or focus
	  // requires that the workspaceElement is on the DOM. Tests that attach the
	  // workspaceElement to the DOM are generally slower than those off DOM.
	  jasmine.attachToDOM(workspaceElement);

	  expect(workspaceElement.querySelector('.super-duplicate')).not.toExist();

	  // This is an activation event, triggering it causes the package to be
	  // activated.
	  atom.commands.dispatch(workspaceElement, 'super-duplicate:duplicate');

	  waitsForPromise(() => {
		return activationPromise;
	  });

	  runs(() => {
		// Now we can test for view visibility
		let superDuplicateElement = workspaceElement.querySelector('.super-duplicate');
		expect(superDuplicateElement).toBeVisible();
		atom.commands.dispatch(workspaceElement, 'super-duplicate:duplicate');
		expect(superDuplicateElement).not.toBeVisible();
	  });
	});
  });
});
